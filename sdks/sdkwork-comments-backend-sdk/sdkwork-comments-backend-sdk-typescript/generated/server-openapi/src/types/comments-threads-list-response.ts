import type { CommentsThread } from './comments-thread';
import type { PageInfo } from './page-info';

export interface CommentsThreadsListResponse {
  code: 0;
  data: unknown & { items: CommentsThread[]; pageInfo: PageInfo; };
  /** Server-owned request correlation id. */
  traceId: string;
}
