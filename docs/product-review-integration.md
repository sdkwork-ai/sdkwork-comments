# Product review integration

The comments capability can back product reviews without a second review model.

## Target mapping

```text
ownerKind = "product-review"
ownerId   = <spu or sku id>
```

Use `skuId` in metadata when reviews are SKU-level, or omit it for SPU-level
reviews.

## Create a review

```json
{
  "body": "材质和做工都不错，使用一周后依然稳定。",
  "rating": 5,
  "authorName": "林同学",
  "metadata": {
    "skuId": "1620",
    "verifiedPurchase": true,
    "dimensions": {
      "quality": 5,
      "value": 4,
      "shipping": 5
    }
  }
}
```

`rating` is constrained to 1–5 by the database and OpenAPI schema.
`metadata` is host-owned JSON, so merchandising can carry SKU, order
verification, or dimension ratings without changing the comments schema.

## List and filter

```text
GET /app/v3/api/comments/threads/{threadId}/comments?sort=newest
GET /app/v3/api/comments/threads/{threadId}/comments?sort=oldest
```

The response includes `rating`, `metadata`, `likeCount`, and `viewerLiked`.

## UI

The generic `CommentThread` accepts:

```tsx
<CommentThread
  enableRating
  rating={rating}
  onRatingChange={setRating}
  comments={comments}
  onSubmit={submitReview}
  onLike={toggleLike}
  onEdit={editReview}
  onDelete={deleteReview}
  canDelete={(comment) => comment.author.id === currentUser.id}
/>
```

Course and news consumers leave `enableRating` off; product reviews enable it.
