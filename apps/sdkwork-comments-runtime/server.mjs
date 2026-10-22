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

function commentView(row) {
  return {
    id: String(row.id),
    threadId: String(row.thread_id),
    parentId: row.parent_comment_id ? String(row.parent_comment_id) : undefined,
    authorId: String(row.author_id),
    body: row.body_text,
    status: row.status,
    createdAt: row.created_at.toISOString(),
    updatedAt: row.updated_at?.toISOString?.(),
    deletedAt: row.deleted_at?.toISOString?.(),
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
  const total = await pool.query(
    `SELECT COUNT(*)::bigint AS count FROM comments_comment
     WHERE tenant_id = $1 AND organization_id = $2 AND thread_id = $3
       AND deleted_at IS NULL AND status = 'published'`,
    [subject.tenantId, subject.organizationId, threadId],
  )
  const rows = await pool.query(
    `SELECT * FROM comments_comment
     WHERE tenant_id = $1 AND organization_id = $2 AND thread_id = $3
       AND deleted_at IS NULL AND status = 'published'
     ORDER BY created_at ASC
     LIMIT $4 OFFSET $5`,
    [subject.tenantId, subject.organizationId, threadId, pageSize, offset],
  )
  return {
    items: rows.rows.map(commentView),
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
  const id = newId()
  const comment = await pool.query(
    `INSERT INTO comments_comment
       (id, uuid, tenant_id, organization_id, thread_id, parent_comment_id, author_id, body_text,
        status, moderation_status, payload_json)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, 'published', 'none', '{}'::jsonb)
     RETURNING *`,
    [
      id,
      randomUUID(),
      subject.tenantId,
      subject.organizationId,
      threadId,
      body.parentId ?? null,
      subject.userId,
      text,
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
      body.parentId ?? null,
      subject.userId,
      text.slice(0, 500),
    ],
  )
  await pool.query(
    `UPDATE comments_thread SET updated_at = CURRENT_TIMESTAMP WHERE id = $1`,
    [threadId],
  )
  return commentView(comment.rows[0])
}

async function threadSummary(subject, threadId) {
  const result = await pool.query(
    `SELECT
       COUNT(*)::int AS total,
       COUNT(*) FILTER (WHERE status = 'published')::int AS published,
       COUNT(*) FILTER (WHERE status = 'pending_review')::int AS pending,
       COUNT(*) FILTER (WHERE status = 'hidden')::int AS hidden,
       COALESCE(MAX(created_at), CURRENT_TIMESTAMP) AS latest
     FROM comments_comment
     WHERE tenant_id = $1 AND organization_id = $2 AND thread_id = $3 AND deleted_at IS NULL`,
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
    replyCount: 0,
    reactionCounts: { likeCount: 0, dislikeCount: 0 },
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
  if (request.method === 'POST' || request.method === 'PUT') {
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
