import type { CommentModerationResponse } from './comment-moderation-response';

export interface CommentsModerationUpdateResponse {
  code: 0;
  data: unknown & { item: CommentModerationResponse; };
  /** Server-owned request correlation id. */
  traceId: string;
}
