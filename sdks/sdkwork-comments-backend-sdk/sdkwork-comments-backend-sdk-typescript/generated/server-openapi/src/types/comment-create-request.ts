export interface CommentCreateRequest {
  body: string;
  parentId?: string;
  quoteId?: string;
  authorName?: string;
  authorAvatarUrl?: string;
  rating?: number;
  metadata?: Record<string, unknown>;
}
