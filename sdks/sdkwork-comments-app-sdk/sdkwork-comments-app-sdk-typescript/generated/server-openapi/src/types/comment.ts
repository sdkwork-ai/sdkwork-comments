import type { CommentQuote } from './comment-quote';
import type { CommentStatus } from './comment-status';

export interface Comment {
  id: string;
  threadId: string;
  parentId?: string;
  rootId?: string;
  quoteId?: string;
  authorName?: string;
  authorAvatarUrl?: string;
  replyCount?: number;
  likeCount?: number;
  viewerLiked?: boolean;
  rating?: number;
  metadata?: Record<string, unknown>;
  editedAt?: string;
  quote?: CommentQuote;
  authorId: string;
  body: string;
  status: CommentStatus;
  createdAt: string;
  updatedAt?: string;
  deletedAt?: string;
}
