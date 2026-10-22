# Comment threading and reuse

The comments capability is content-domain agnostic. A host supplies an
`ownerKind` and `ownerId`; the capability owns the thread, comments, replies,
quotes, reactions, and engagement projections.

## Target model

- `ownerKind` is an open lower-kebab token such as `course`, `course-lesson`,
  `news-item`, `article`, `video`, or `market-item`.
- `ownerId` is the host's stable identifier for that content item.
- A thread is unique per tenant, organization, owner kind, and owner id, so two
  products can share the same comment runtime without sharing content tables.

## Threading model

Comments use a two-level display thread:

- A root comment has no `parentId`.
- A reply has `parentId` and `rootId`.
- A reply to another reply keeps the same `rootId`, so the UI can render one
  indented conversation instead of an unbounded tree.
- `quoteId` points at the comment being quoted. The API returns a compact
  `quote` snapshot (author name and body) so deleted or hidden targets do not
  break rendering.

## Author snapshot

The host may send `authorName` and `authorAvatarUrl` when creating a comment.
The capability stores the snapshot with the comment, keeping rendering stable
without a synchronous dependency on IAM or profile services.

## API surface

- `POST /comments/threads/ensure`
- `GET /comments/threads/{threadId}/comments?sort=newest|oldest&parent_id=&root_id=`
- `POST /comments/threads/{threadId}/comments` with
  `{ body, parentId?, quoteId?, authorName?, authorAvatarUrl? }`
- Comment responses include `rootId`, `quoteId`, `replyCount`, `likeCount`,
  `viewerLiked`, `rating`, `metadata`, and `quote`.
- `PATCH /comments/comments/{commentId}` edits the caller's comment.
- `DELETE /comments/comments/{commentId}` soft-deletes the caller's comment.
- `PUT/DELETE /comments/comments/{commentId}/reactions/{reactionType}` manages
  likes and other comment reactions.
- Reactions and engagement remain available through the same SDK.

## Product reviews

Set `ownerKind` to `product-review` or `market-item`, and send an optional
`rating` (1–5) plus host-owned `metadata`:

```json
{
  "body": "材质和做工都不错。",
  "rating": 5,
  "metadata": {
    "skuId": "1620",
    "verifiedPurchase": true
  }
}
```

The same thread, reply, quote, like, and moderation surfaces apply. See
`product-review-integration.md` for the UI adapter example.

## Host integration

A host adapter maps its content identifiers to `ownerKind`/`ownerId`, maps SDK
comments to a generic view model, and passes callbacks to the presentation
layer. The supplied `CommentThread` component is intentionally independent of
course or news types; it only receives comment view models and submit
callbacks.
