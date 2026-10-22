import type { EngagementFavoritesListResponse } from './engagement-favorites-list-response';

export interface EngagementFavoritesListGetResponse {
  code: 0;
  data: unknown & EngagementFavoritesListResponse;
  /** Server-owned request correlation id. */
  traceId: string;
}
