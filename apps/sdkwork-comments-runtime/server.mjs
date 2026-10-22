import { createServer } from 'node:http'
import { randomUUID } from 'node:crypto'
import pg from 'file:///D:/sdkwork-space/sdkwork-im/apps/sdkwork-im-pc/node_modules/pg/lib/index.js'

const { Pool } = pg
const pool = new Pool({
  host: process.env.PGHOST ?? '127.0.0.1',
  port: Number(process.env.PGPORT ?? 5432),
  user: process.env.PGUSER ?? 'sdkwork_ai_dev',
  password: process.env.PGPASSWORD ?? 'sdkworkdev123',
  database: process.env.PGDATABASE ?? 'sdkwork_ai_dev',
})
const port = Number(process.env.COMMENTS_PORT ?? 3901)

function envelope(data, status = 200) {
  return {
    status,
    body: JSON.stringify({ code: 0, data, traceId: randomUUID() }),
  }
}

function problem(status, title, detail) {
  return {
    status,
    body: JSON.stringify({
      type: `https://docs.sdkwork.com/problems/${status}01`,
      title,
      status,
      detail,
      code: status * 100 + 1,
      traceId: randomUUID(),
    }),
  }
}

function decodeSubject(request) {
  const authorization = request.headers.authorization ?? ''
  const token =
    (request.headers['access-token'] ?? '').toString() ||
    (authorization.toLowerCase().startsWith('bearer ') ? authorization.slice(7) : '')
  if (!token) return null
  try {
    const payload = JSON.parse(Buffer.from(token.split('.')[1], 'base64url').toString('utf8'))
    const tenant = String(payload.tenant_id ?? '')
    const user = String(payload.user_id ?? '')
    if (!tenant || !user) return null
    return {
      tenantId: tenant,
      userId: user,
      organizationId: String(payload.organization_id ?? '0'),
    }
  } catch {
    return null
  }
}

function newId() {
  return (BigInt(Date.now()) * 1000n + BigInt(Math.floor(Math.random() * 1000))).toString()
}

function parsePage(url) {
  const page = Math.max(1, Number(url.searchParams.get('page') ?? '1') || 1)
  const pageSize = Math.min(100, Math.max(1, Number(url.searchParams.get('page_size') ?? '20') || 20))
  return { page, pageSize, offset: (page - 1) * pageSize }
}

function threadView(row) {
  return {
    id: String(row.id),
    tenantId: String(row.tenant_id),
    ownerId: row.owner_id,
    ownerKind: row.owner_kind,
    title: row.title ?? undefined,
    locked: row.locked,
    closedAt: row.closed_at?.toISOString?.() ?? row.closed_at ?? undefined,
  }
}

function commentView(row, quote) {
  return {
    id: String(row.id),
    threadId: String(row.thread_id),
    parentId: row.parent_comment_id ? String(row.parent_comment_id) : undefined,
    rootId: row.root_comment_id ? String(row.root_comment_id) : undefined,
    quoteId: row.quote_comment_id ? String(row.quote_comment_id) : undefined,
    authorId: String(row.author_id),
    authorName: row.author_name ?? `鐢ㄦ埛 ${String(row.author_id).slice(-4)}`,
    authorAvatarUrl: row.author_avatar_url ?? undefined,
    body: row.body_text,
    status: row.status,
    replyCount: Number(row.reply_count ?? 0),
    likeCount: Number(row.like_count ?? 0),
    viewerLiked: Boolean(row.viewer_liked),
    rating: row.rating == null ? undefined : Number(row.rating),
    metadata: row.metadata_json ?? {},
    editedAt: row.edited_at?.toISOString?.(),
    quote: quote ?? undefined,
    createdAt: row.created_at.toISOString(),
    updatedAt: row.updated_at?.toISOString?.(),
    deletedAt: row.deleted_at?.toISOString?.(),
  }
}

function quoteView(row) {
  if (!row?.quote_ref_id) return undefined
  return {
    id: String(row.quote_ref_id),
    authorId: String(row.quote_author_id ?? 0),
    authorName: row.quote_author_name ?? `鐢ㄦ埛 ${String(row.quote_author_id ?? 0).slice(-4)}`,
    body: row.quote_body ?? '',
    createdAt: row.quote_created_at?.toISOString?.(),
  }
}

async function ensureThread(subject, body) {
  const ownerKind = String(body.ownerKind ?? '').trim()
  const ownerId = String(body.ownerId ?? '').trim()
  if (!ownerKind || !ownerId) return null
  const existing = await pool.query(
    `SELECT * FROM comments_thread
     WHERE tenant_id = $1 AND organization_id = $2 AND owner_kind = $3 AND owner_id = $4
       AND deleted_at IS NULL
     LIMIT 1`,
    [subject.tenantId, subject.organizationId, ownerKind, ownerId],
  )
  if (existing.rows[0]) return existing.rows[0]
  const inserted = await pool.query(
    `INSERT INTO comments_thread
       (id, uuid, tenant_id, organization_id, owner_kind, owner_id, title, locked, status, payload_json)
     VALUES ($1, $2, $3, $4, $5, $6, $7, FALSE, 'open', '{}'::jsonb)
     RETURNING *`,
    [newId(), randomUUID(), subject.tenantId, subject.organizationId, ownerKind, ownerId, body.title ?? null],
  )
  return inserted.rows[0]
}

async function loadThread(subject, threadId) {
  const result = await pool.query(
    `SELECT * FROM comments_thread
     WHERE id = $1 AND tenant_id = $2 AND organization_id = $3 AND deleted_at IS NULL`,
    [threadId, subject.tenantId, subject.organizationId],
  )
  return result.rows[0] ?? null
}

async function listComments(subject, threadId, url) {
  const { page, pageSize, offset } = parsePage(url)
  const sort = url.searchParams.get('sort') === 'oldest' ? 'ASC' : 'DESC'
  const conditions = [
    'c.tenant_id = $1',
    'c.organization_id = $2',
    'c.thread_id = $3',
    'c.deleted_at IS NULL',
    "c.status = 'published'",
  ]
  const values = [subject.tenantId, subject.organizationId, threadId]
  const parentId = url.searchParams.get('parent_id')
  const rootId = url.searchParams.get('root_id')
  if (parentId) {
    values.push(parentId)
    conditions.push(`c.parent_comment_id = $${values.length}`)
  }
  if (rootId) {
    values.push(rootId)
    conditions.push(
      `(c.root_comment_id = $${values.length} OR c.id = $${values.length})`,
    )
  }
  const where = conditions.join(' AND ')
  const total = await pool.query(
    `SELECT COUNT(*)::bigint AS count FROM comments_comment c WHERE ${where}`,
    values,
  )
  const rows = await pool.query(
    `SELECT c.*,
            COALESCE(c.reply_count, 0) AS reply_count,
            (SELECT COUNT(*)::int FROM comments_reaction r
              WHERE r.comment_id = c.id AND r.reaction_type = 'like') AS like_count,
            EXISTS(SELECT 1 FROM comments_reaction r
              WHERE r.comment_id = c.id AND r.reaction_type = 'like'
                AND r.user_id = $${values.length + 3}) AS viewer_liked,
            q.id AS quote_ref_id,
            q.author_id AS quote_author_id,
            q.author_name AS quote_author_name,
            q.body_text AS quote_body,
            q.created_at AS quote_created_at
     FROM comments_comment c
     LEFT JOIN comments_comment q
       ON q.id = c.quote_comment_id AND q.thread_id = c.thread_id
     WHERE ${where}
     ORDER BY COALESCE(c.root_comment_id, c.id) ${sort}, c.created_at ASC
     LIMIT $${values.length + 1} OFFSET $${values.length + 2}`,
    [...values, pageSize, offset, subject.userId],
  )
  return {
    items: rows.rows.map((row) => commentView(row, quoteView(row))),
    pageInfo: {
      page,
      pageSize,
      totalItems: Number(total.rows[0].count),
      totalPages: Math.max(1, Math.ceil(Number(total.rows[0].count) / pageSize)),
    },
  }
}

async function createComment(subject, threadId, body) {
  const text = String(body.body ?? '').trim()
  if (!text) return null
  const parentId = body.parentId ? String(body.parentId) : null
  const quoteId = body.quoteId ? String(body.quoteId) : null
  let parent = null
  if (parentId) {
    const parentResult = await pool.query(
      `SELECT * FROM comments_comment
       WHERE id = $1 AND tenant_id = $2 AND organization_id = $3 AND thread_id = $4
         AND deleted_at IS NULL AND status = 'published'`,
      [parentId, subject.tenantId, subject.organizationId, threadId],
    )
    parent = parentResult.rows[0] ?? null
    if (!parent) return null
  }
  let quote = null
  if (quoteId) {
    const quoteResult = await pool.query(
      `SELECT * FROM comments_comment
       WHERE id = $1 AND tenant_id = $2 AND organization_id = $3 AND thread_id = $4
         AND deleted_at IS NULL AND status = 'published'`,
      [quoteId, subject.tenantId, subject.organizationId, threadId],
    )
    quote = quoteResult.rows[0] ?? null
    if (!quote) return null
  }
  const rootId = parent ? (parent.root_comment_id ?? parent.id) : null
  const authorName = String(body.authorName ?? '').trim().slice(0, 128)
    || `鐢ㄦ埛 ${String(subject.userId).slice(-4)}`
  const authorAvatarUrl = String(body.authorAvatarUrl ?? '').trim().slice(0, 2048) || null
  const ratingValue = body.rating == null ? null : Number(body.rating)
  const rating = Number.isInteger(ratingValue) && ratingValue >= 1 && ratingValue <= 5
    ? ratingValue
    : null
  const metadataJson = body.metadata && typeof body.metadata === 'object' && !Array.isArray(body.metadata)
    ? JSON.stringify(body.metadata)
    : '{}'
  const metadata = metadataJson.length <= 16000 ? metadataJson : '{}'
  const id = newId()
  const comment = await pool.query(
    `INSERT INTO comments_comment
       (id, uuid, tenant_id, organization_id, thread_id, parent_comment_id, root_comment_id,
        quote_comment_id, author_id, author_name, author_avatar_url, body_text,
        rating, metadata_json, status, moderation_status, payload_json)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14::jsonb, 'published', 'none', '{}'::jsonb)
     RETURNING *`,
    [
      id,
      randomUUID(),
      subject.tenantId,
      subject.organizationId,
      threadId,
      parentId,
      rootId,
      quoteId,
      subject.userId,
      authorName,
      authorAvatarUrl,
      text,
      rating,
      metadata,
    ],
  )
  await pool.query(
    `INSERT INTO comments_comment_projection
       (id, uuid, tenant_id, organization_id, thread_id, comment_id, parent_comment_id, author_id,
        body_preview, status)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 'published')`,
    [
      newId(),
      randomUUID(),
      subject.tenantId,
      subject.organizationId,
      threadId,
      id,
      parentId,
      subject.userId,
      text.slice(0, 500),
    ],
  )
  if (parentId) {
    await pool.query(
      `UPDATE comments_comment SET reply_count = reply_count + 1
       WHERE id = $1 AND tenant_id = $2 AND organization_id = $3 AND thread_id = $4`,
      [parentId, subject.tenantId, subject.organizationId, threadId],
    )
  }
  await pool.query(
    `UPDATE comments_thread SET updated_at = CURRENT_TIMESTAMP WHERE id = $1`,
    [threadId],
  )
  return commentView(comment.rows[0], quote ? {
    id: String(quote.id),
    authorId: String(quote.author_id),
    authorName: quote.author_name ?? `鐢ㄦ埛 ${String(quote.author_id).slice(-4)}`,
    body: quote.body_text,
    createdAt: quote.created_at?.toISOString?.(),
  } : undefined)
}

async function updateComment(subject, commentId, body) {
  const text = String(body.body ?? '').trim()
  if (!text) return null
  const result = await pool.query(
    `UPDATE comments_comment
     SET body_text = $1, edited_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP,
         version = version + 1
     WHERE id = $2 AND tenant_id = $3 AND organization_id = $4
       AND author_id = $5 AND deleted_at IS NULL AND status = 'published'
     RETURNING *`,
    [text, commentId, subject.tenantId, subject.organizationId, subject.userId],
  )
  const row = result.rows[0]
  if (!row) return null
  await pool.query(
    `UPDATE comments_comment_projection
     SET body_preview = $1
     WHERE comment_id = $2 AND tenant_id = $3 AND organization_id = $4`,
    [text.slice(0, 500), commentId, subject.tenantId, subject.organizationId],
  )
  return commentView(row)
}

async function deleteComment(subject, commentId) {
  const result = await pool.query(
    `UPDATE comments_comment
     SET status = 'deleted', deleted_at = CURRENT_TIMESTAMP, deleted_by = $1,
         updated_at = CURRENT_TIMESTAMP, version = version + 1
     WHERE id = $2 AND tenant_id = $3 AND organization_id = $4
       AND author_id = $1 AND deleted_at IS NULL
     RETURNING parent_comment_id, thread_id`,
    [subject.userId, commentId, subject.tenantId, subject.organizationId],
  )
  const row = result.rows[0]
  if (!row) return false
  if (row.parent_comment_id) {
    await pool.query(
      `UPDATE comments_comment SET reply_count = GREATEST(reply_count - 1, 0)
       WHERE id = $1 AND tenant_id = $2 AND organization_id = $3`,
      [row.parent_comment_id, subject.tenantId, subject.organizationId],
    )
  } else {
    await pool.query(
      `UPDATE comments_comment
       SET status = 'deleted', deleted_at = CURRENT_TIMESTAMP, deleted_by = $1,
           updated_at = CURRENT_TIMESTAMP, version = version + 1
       WHERE root_comment_id = $2 AND tenant_id = $3 AND organization_id = $4
         AND deleted_at IS NULL`,
      [subject.userId, commentId, subject.tenantId, subject.organizationId],
    )
    await pool.query(
      `UPDATE comments_comment_projection SET status = 'deleted'
       WHERE parent_comment_id = $1 AND tenant_id = $2 AND organization_id = $3`,
      [commentId, subject.tenantId, subject.organizationId],
    )
  }
  await pool.query(
    `UPDATE comments_comment_projection SET status = 'deleted'
     WHERE comment_id = $1 AND tenant_id = $2 AND organization_id = $3`,
    [commentId, subject.tenantId, subject.organizationId],
  )
  return true
}

async function updateCommentReaction(subject, commentId, reactionType) {
  const allowed = new Set(['like', 'dislike', 'heart', 'flag'])
  if (!allowed.has(reactionType)) return null
  const comment = await pool.query(
    `SELECT id, thread_id FROM comments_comment
     WHERE id = $1 AND tenant_id = $2 AND organization_id = $3
       AND deleted_at IS NULL AND status = 'published'`,
    [commentId, subject.tenantId, subject.organizationId],
  )
  if (!comment.rows[0]) return null
  const result = await pool.query(
    `INSERT INTO comments_reaction
       (id, uuid, tenant_id, organization_id, thread_id, comment_id, user_id, reaction_type, payload_json)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, '{}'::jsonb)
     ON CONFLICT (tenant_id, organization_id, comment_id, user_id, reaction_type)
     DO UPDATE SET updated_at = CURRENT_TIMESTAMP, version = comments_reaction.version + 1
     RETURNING *`,
    [
      newId(),
      randomUUID(),
      subject.tenantId,
      subject.organizationId,
      comment.rows[0].thread_id,
      commentId,
      subject.userId,
      reactionType,
    ],
  )
  const row = result.rows[0]
  return {
    commentId: String(row.comment_id),
    userId: String(row.user_id),
    reactionType: row.reaction_type,
    createdAt: row.created_at.toISOString(),
  }
}

async function deleteCommentReaction(subject, commentId, reactionType) {
  await pool.query(
    `DELETE FROM comments_reaction
     WHERE comment_id = $1 AND tenant_id = $2 AND organization_id = $3
       AND user_id = $4 AND reaction_type = $5`,
    [commentId, subject.tenantId, subject.organizationId, subject.userId, reactionType],
  )
}

async function threadSummary(subject, threadId) {
  const result = await pool.query(
    `SELECT
       COUNT(*)::int AS total,
       COUNT(*) FILTER (WHERE status = 'published')::int AS published,
       COUNT(*) FILTER (WHERE status = 'pending_review')::int AS pending,
       COUNT(*) FILTER (WHERE status = 'hidden')::int AS hidden,
       COUNT(*) FILTER (WHERE parent_comment_id IS NOT NULL)::int AS replies,
       AVG(rating)::numeric(3,2) AS average_rating,
       COUNT(rating)::int AS rating_count,
       COALESCE(MAX(created_at), CURRENT_TIMESTAMP) AS latest
     FROM comments_comment
     WHERE tenant_id = $1 AND organization_id = $2 AND thread_id = $3 AND deleted_at IS NULL`,
    [subject.tenantId, subject.organizationId, threadId],
  )
  const reactions = await pool.query(
    `SELECT
       COUNT(*) FILTER (WHERE reaction_type = 'like')::int AS likes,
       COUNT(*) FILTER (WHERE reaction_type = 'dislike')::int AS dislikes
     FROM comments_reaction
     WHERE tenant_id = $1 AND organization_id = $2 AND thread_id = $3`,
    [subject.tenantId, subject.organizationId, threadId],
  )
  const row = result.rows[0]
  const thread = await loadThread(subject, threadId)
  return {
    threadId: String(threadId),
    tenantId: subject.tenantId,
    ownerId: thread?.owner_id ?? '',
    ownerKind: thread?.owner_kind ?? 'course',
    title: thread?.title ?? undefined,
    totalCount: row.total,
    publishedCount: row.published,
    pendingReviewCount: row.pending,
    hiddenCount: row.hidden,
    replyCount: row.replies,
    averageRating: row.average_rating == null ? undefined : Number(row.average_rating),
    ratingCount: row.rating_count,
    reactionCounts: {
      likeCount: reactions.rows[0]?.likes ?? 0,
      dislikeCount: reactions.rows[0]?.dislikes ?? 0,
    },
    latestActivityAt: row.latest.toISOString(),
  }
}

async function listFavorites(subject, url) {
  const { page, pageSize, offset } = parsePage(url)
  const conditions = ['tenant_id = $1', 'organization_id = $2', 'user_id = $3']
  const values = [subject.tenantId, subject.organizationId, subject.userId]
  const targetKind = url.searchParams.get('target_kind')
  const targetId = url.searchParams.get('target_id')
  if (targetKind) {
    values.push(targetKind)
    conditions.push(`target_kind = $${values.length}`)
  }
  if (targetId) {
    values.push(targetId)
    conditions.push(`target_id = $${values.length}`)
  }
  const where = conditions.join(' AND ')
  const total = await pool.query(`SELECT COUNT(*)::bigint AS count FROM comments_engagement_favorite WHERE ${where}`, values)
  const rows = await pool.query(
    `SELECT * FROM comments_engagement_favorite WHERE ${where}
     ORDER BY created_at DESC LIMIT $${values.length + 1} OFFSET $${values.length + 2}`,
    [...values, pageSize, offset],
  )
  return {
    items: rows.rows.map((row) => ({
      targetKind: row.target_kind,
      targetId: row.target_id,
      userId: String(row.user_id),
      createdAt: row.created_at.toISOString(),
    })),
    pageInfo: {
      page,
      pageSize,
      totalItems: Number(total.rows[0].count),
      totalPages: Math.max(1, Math.ceil(Number(total.rows[0].count) / pageSize)),
    },
  }
}

async function favoriteTarget(subject, targetKind, targetId) {
  const existing = await pool.query(
    `SELECT * FROM comments_engagement_favorite
     WHERE tenant_id = $1 AND organization_id = $2 AND target_kind = $3 AND target_id = $4 AND user_id = $5`,
    [subject.tenantId, subject.organizationId, targetKind, targetId, subject.userId],
  )
  const row =
    existing.rows[0] ??
    (
      await pool.query(
        `INSERT INTO comments_engagement_favorite
           (id, uuid, tenant_id, organization_id, target_kind, target_id, user_id, payload_json)
         VALUES ($1, $2, $3, $4, $5, $6, $7, '{}'::jsonb)
         RETURNING *`,
        [newId(), randomUUID(), subject.tenantId, subject.organizationId, targetKind, targetId, subject.userId],
      )
    ).rows[0]
  await refreshProjection(subject, targetKind, targetId)
  return {
    targetKind,
    targetId,
    userId: String(row.user_id),
    createdAt: row.created_at.toISOString(),
  }
}

async function unfavoriteTarget(subject, targetKind, targetId) {
  await pool.query(
    `DELETE FROM comments_engagement_favorite
     WHERE tenant_id = $1 AND organization_id = $2 AND target_kind = $3 AND target_id = $4 AND user_id = $5`,
    [subject.tenantId, subject.organizationId, targetKind, targetId, subject.userId],
  )
  await refreshProjection(subject, targetKind, targetId)
}

async function recordVisit(subject, targetKind, targetId, body) {
  const row = await pool.query(
    `INSERT INTO comments_engagement_visit_history
       (id, uuid, tenant_id, organization_id, target_kind, target_id, user_id, visit_source, payload_json)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, '{}'::jsonb)
     RETURNING *`,
    [
      newId(),
      randomUUID(),
      subject.tenantId,
      subject.organizationId,
      targetKind,
      targetId,
      subject.userId,
      body.source ?? 'app',
    ],
  )
  await refreshProjection(subject, targetKind, targetId)
  return {
    visitId: String(row.rows[0].id),
    targetKind,
    targetId,
    userId: String(row.rows[0].user_id),
    source: row.rows[0].visit_source ?? undefined,
    createdAt: row.rows[0].created_at.toISOString(),
  }
}

async function listVisits(subject, url) {
  const { page, pageSize, offset } = parsePage(url)
  const conditions = ['tenant_id = $1', 'organization_id = $2', 'user_id = $3']
  const values = [subject.tenantId, subject.organizationId, subject.userId]
  const targetKind = url.searchParams.get('target_kind')
  const targetId = url.searchParams.get('target_id')
  if (targetKind) {
    values.push(targetKind)
    conditions.push(`target_kind = $${values.length}`)
  }
  if (targetId) {
    values.push(targetId)
    conditions.push(`target_id = $${values.length}`)
  }
  const where = conditions.join(' AND ')
  const total = await pool.query(`SELECT COUNT(*)::bigint AS count FROM comments_engagement_visit_history WHERE ${where}`, values)
  const rows = await pool.query(
    `SELECT * FROM comments_engagement_visit_history WHERE ${where}
     ORDER BY created_at DESC LIMIT $${values.length + 1} OFFSET $${values.length + 2}`,
    [...values, pageSize, offset],
  )
  return {
    items: rows.rows.map((row) => ({
      visitId: String(row.id),
      targetKind: row.target_kind,
      targetId: row.target_id,
      userId: String(row.user_id),
      source: row.visit_source ?? undefined,
      createdAt: row.created_at.toISOString(),
    })),
    pageInfo: {
      page,
      pageSize,
      totalItems: Number(total.rows[0].count),
      totalPages: Math.max(1, Math.ceil(Number(total.rows[0].count) / pageSize)),
    },
  }
}

async function refreshProjection(subject, targetKind, targetId) {
  const counts = await pool.query(
    `SELECT
       (SELECT COUNT(*)::int FROM comments_engagement_favorite
        WHERE tenant_id = $1 AND organization_id = $2 AND target_kind = $3 AND target_id = $4) AS favorites,
       (SELECT COUNT(*)::int FROM comments_engagement_visit_history
        WHERE tenant_id = $1 AND organization_id = $2 AND target_kind = $3 AND target_id = $4) AS visits,
       (SELECT COUNT(DISTINCT user_id)::int FROM comments_engagement_visit_history
        WHERE tenant_id = $1 AND organization_id = $2 AND target_kind = $3 AND target_id = $4) AS visitors`,
    [subject.tenantId, subject.organizationId, targetKind, targetId],
  )
  const row = counts.rows[0]
  await pool.query(
    `INSERT INTO comments_engagement_projection
       (id, uuid, tenant_id, organization_id, target_kind, target_id, favorite_count, visit_count,
        unique_visitor_count, payload_json, updated_at)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, '{}'::jsonb, CURRENT_TIMESTAMP)
     ON CONFLICT (tenant_id, organization_id, target_kind, target_id)
     DO UPDATE SET favorite_count = EXCLUDED.favorite_count, visit_count = EXCLUDED.visit_count,
                   unique_visitor_count = EXCLUDED.unique_visitor_count, updated_at = CURRENT_TIMESTAMP`,
    [newId(), randomUUID(), subject.tenantId, subject.organizationId, targetKind, targetId, row.favorites, row.visits, row.visitors],
  )
}

async function engagementSummary(subject, targetKind, targetId) {
  const result = await pool.query(
    `SELECT * FROM comments_engagement_projection
     WHERE tenant_id = $1 AND organization_id = $2 AND target_kind = $3 AND target_id = $4`,
    [subject.tenantId, subject.organizationId, targetKind, targetId],
  )
  const row = result.rows[0]
  return {
    targetKind,
    targetId,
    reactionCounts: { likeCount: 0, dislikeCount: 0 },
    favoriteCount: row?.favorite_count ?? 0,
    visitCount: row?.visit_count ?? 0,
    uniqueVisitorCount: row?.unique_visitor_count ?? 0,
    latestActivityAt: row?.updated_at?.toISOString?.() ?? new Date().toISOString(),
  }
}

const server = createServer(async (request, response) => {
  const cors = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'content-type,authorization,access-token,idempotency-key,x-content-sha256',
    'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
  }
  if (request.method === 'OPTIONS') {
    response.writeHead(204, cors)
    response.end()
    return
  }
  const url = new URL(request.url ?? '/', `http://${request.headers.host ?? '127.0.0.1'}`)
  const subject = decodeSubject(request)
  if (!subject) {
    const result = problem(401, 'Unauthorized', 'A valid SDKWork access token is required')
    response.writeHead(result.status, { ...cors, 'Content-Type': 'application/json' })
    response.end(result.body)
    return
  }
  let body = {}
  if (request.method === 'POST' || request.method === 'PUT' || request.method === 'PATCH') {
    let raw = ''
    for await (const chunk of request) raw += chunk
    if (raw) {
      try {
        body = JSON.parse(raw)
      } catch {
        body = {}
      }
    }
  }
  try {
    const path = url.pathname
    let result = null
    if (path === '/health') {
      response.writeHead(200, { ...cors, 'Content-Type': 'application/json' })
      response.end(JSON.stringify({ status: 'ok' }))
      return
    }
    if (path === '/app/v3/api/comments/threads/ensure' && request.method === 'POST') {
      const thread = await ensureThread(subject, body)
      if (!thread) result = problem(422, 'Unprocessable entity', 'ownerKind and ownerId are required')
      else result = envelope({ item: threadView(thread) }, 201)
    } else if (path.startsWith('/app/v3/api/comments/comments/')) {
      const segments = path.split('/').filter(Boolean)
      const commentId = segments[5]
      const reactionType = segments[7]
      if (segments[6] === 'reactions' && request.method === 'PUT') {
        const reaction = await updateCommentReaction(subject, commentId, reactionType)
        result = reaction
          ? envelope({ item: { reaction } })
          : problem(404, 'Not found', 'Comment was not found')
      } else if (segments[6] === 'reactions' && request.method === 'DELETE') {
        await deleteCommentReaction(subject, commentId, reactionType)
        result = envelope({})
      } else if (!segments[6] && request.method === 'PATCH') {
        const comment = await updateComment(subject, commentId, body)
        result = comment
          ? envelope({ item: { comment } })
          : problem(404, 'Not found', 'Comment was not found or not owned by caller')
      } else if (!segments[6] && request.method === 'DELETE') {
        const deleted = await deleteComment(subject, commentId)
        result = deleted
          ? envelope({})
          : problem(404, 'Not found', 'Comment was not found or not owned by caller')
      }
    } else if (path.startsWith('/app/v3/api/comments/threads/')) {
      const segments = path.split('/').filter(Boolean)
      const threadId = segments[5]
      if (segments[6] === 'comments') {
        const thread = await loadThread(subject, threadId)
        if (!thread) result = problem(404, 'Not found', 'Comment thread was not found')
        else if (request.method === 'GET') result = envelope(await listComments(subject, threadId, url))
        else if (request.method === 'POST') {
          const comment = await createComment(subject, threadId, body)
          result = comment ? envelope({ item: { comment } }, 201) : problem(422, 'Unprocessable entity', 'body is required')
        }
      } else if (request.method === 'GET') {
        const summary = await threadSummary(subject, threadId)
        result = envelope({ item: { summary } })
      }
    } else if (path.startsWith('/app/v3/api/engagement/targets/')) {
      const segments = path.split('/').filter(Boolean)
      const targetKind = segments[5]
      const targetId = decodeURIComponent(segments[6] ?? '')
      const action = segments[7]
      if (action === 'favorites' && request.method === 'PUT') {
        result = envelope({ item: { favorite: await favoriteTarget(subject, targetKind, targetId) } }, 201)
      } else if (action === 'favorites' && request.method === 'DELETE') {
        await unfavoriteTarget(subject, targetKind, targetId)
        result = envelope({}, 200)
      } else if (action === 'visits' && request.method === 'POST') {
        result = envelope({ item: { visit: await recordVisit(subject, targetKind, targetId, body) } }, 201)
      } else if (!action && request.method === 'GET') {
        result = envelope({ item: { summary: await engagementSummary(subject, targetKind, targetId) } })
      }
    } else if (path === '/app/v3/api/engagement/visits' && request.method === 'GET') {
      result = envelope(await listVisits(subject, url))
    } else if (path === '/app/v3/api/engagement/favorites' && request.method === 'GET') {
      result = envelope(await listFavorites(subject, url))
    }
    if (!result) result = problem(404, 'Not found', 'Route was not found')
    response.writeHead(result.status, { ...cors, 'Content-Type': 'application/json' })
    response.end(result.body)
  } catch (error) {
    console.error('comments runtime error', error)
    const result = problem(500, 'Internal server error', 'Comments runtime failed')
    response.writeHead(result.status, { ...cors, 'Content-Type': 'application/json' })
    response.end(result.body)
  }
})

server.listen(port, '127.0.0.1', () => {
  console.log(`sdkwork comments runtime listening on http://127.0.0.1:${port}`)
})
