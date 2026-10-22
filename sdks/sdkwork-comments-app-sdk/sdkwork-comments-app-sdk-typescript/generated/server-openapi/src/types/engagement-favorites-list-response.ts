import type { EngagementFavorite } from './engagement-favorite';
import type { PageInfo } from './page-info';

export interface EngagementFavoritesListResponse {
  items: EngagementFavorite[];
  pageInfo: PageInfo;
}
