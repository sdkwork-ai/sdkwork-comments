import type { CommentStatus } from './comment-status';

export interface Comment {
  id: string;
  threadId: string;
  parentId?: string;
  authorId: string;
  rating?: number;
  metadata?: Record<string, unknown>;
  likeCount?: number;
  viewerLiked?: boolean;
  editedAt?: string;
  body: string;
  status: CommentStatus;
  createdAt: string;
  updatedAt?: string;
  deletedAt?: string;
}
