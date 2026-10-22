import type { CommentsThread } from './comments-thread';

export interface CommentsThreadsEnsureResponse201 {
  code: 0;
  data: unknown & { item: CommentsThread; };
  /** Server-owned request correlation id. */
  traceId: string;
}
