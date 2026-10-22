import type { CommentModerationCase } from './comment-moderation-case';
import type { PageInfo } from './page-info';

export interface CommentsModerationCasesListResponse {
  code: 0;
  data: unknown & { items: CommentModerationCase[]; pageInfo: PageInfo; };
  /** Server-owned request correlation id. */
  traceId: string;
}
