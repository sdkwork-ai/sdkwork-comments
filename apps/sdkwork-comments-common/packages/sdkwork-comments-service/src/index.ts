import {
  normalizeCommentBody,
  type SdkworkCommentCreateRequest,
  type SdkworkCommentDeleteResponse,
  type SdkworkCommentModerationCaseListResponse,
  type SdkworkCommentModerationRequest,
  type SdkworkCommentModerationResponse,
  type SdkworkCommentReactionDeleteResponse,
  type SdkworkCommentReactionResponse,
  type SdkworkCommentReactionType,
  type SdkworkCommentResponse,
  type SdkworkCommentUpdateRequest,
  type SdkworkCommentsListRequest,
  type SdkworkCommentsListResponse,
  type SdkworkCommentsThread,
  type SdkworkCommentsThreadEnsureRequest,
  type SdkworkCommentsThreadListResponse,
  type SdkworkCommentsThreadSummaryResponse,
  type SdkworkEngagementFavoriteDeleteResponse,
  type SdkworkEngagementFavoriteResponse,
  type SdkworkEngagementReactionDeleteResponse,
  type SdkworkEngagementReactionResponse,
  type SdkworkEngagementSummaryResponse,
  type SdkworkEngagementTargetKind,
  type SdkworkEngagementVisitCreateRequest,
  type SdkworkEngagementVisitListRequest,
  type SdkworkEngagementVisitListResponse,
  type SdkworkEngagementVisitResponse,
} from "@sdkwork/comments-contracts";

export interface SdkworkCommentsAppSdkClient {
  comments: {
    comments: {
      create(
        threadId: string,
        body: SdkworkCommentCreateRequest,
      ): Promise<SdkworkCommentResponse>;
      delete(commentId: string): Promise<void>;
      list(
        threadId: string,
        params?: SdkworkCommentsListRequest,
      ): Promise<SdkworkCommentsListResponse>;
      update(
        commentId: string,
        body: SdkworkCommentUpdateRequest,
      ): Promise<SdkworkCommentResponse>;
    };
    reactions: {
      delete(
        commentId: string,
        reactionType: SdkworkCommentReactionType,
      ): Promise<void>;
      update(
        commentId: string,
        reactionType: SdkworkCommentReactionType,
      ): Promise<SdkworkCommentReactionResponse>;
    };
    threads: {
      ensure(
        body: SdkworkCommentsThreadEnsureRequest,
      ): Promise<SdkworkCommentsThread>;
      retrieve(threadId: string): Promise<SdkworkCommentsThreadSummaryResponse>;
    };
  };
  engagement: {
    favorites: {
      delete(targetKind: SdkworkEngagementTargetKind, targetId: string): Promise<void>;
      update(
        targetKind: SdkworkEngagementTargetKind,
        targetId: string,
      ): Promise<SdkworkEngagementFavoriteResponse>;
    };
    likes: {
      delete(targetKind: SdkworkEngagementTargetKind, targetId: string): Promise<void>;
      update(
        targetKind: SdkworkEngagementTargetKind,
        targetId: string,
      ): Promise<SdkworkEngagementReactionResponse>;
    };
    targets: {
      retrieve(
        targetKind: SdkworkEngagementTargetKind,
        targetId: string,
      ): Promise<SdkworkEngagementSummaryResponse>;
    };
    visits: {
      create(
        targetKind: SdkworkEngagementTargetKind,
        targetId: string,
        body: SdkworkEngagementVisitCreateRequest,
      ): Promise<SdkworkEngagementVisitResponse>;
      list(params?: SdkworkEngagementVisitListRequest): Promise<SdkworkEngagementVisitListResponse>;
    };
  };
}

export interface SdkworkCommentsBackendSdkClient {
  comments: {
    comments: {
      delete(commentId: string): Promise<void>;
      list(
        threadId: string,
        params?: SdkworkCommentsListRequest,
      ): Promise<SdkworkCommentsListResponse>;
    };
    moderation: {
      cases: {
        list(
          params?: SdkworkCommentsListRequest,
        ): Promise<SdkworkCommentModerationCaseListResponse>;
      };
      update(
        commentId: string,
        body: SdkworkCommentModerationRequest,
      ): Promise<SdkworkCommentModerationResponse>;
    };
    threads: {
      list(params?: SdkworkCommentsListRequest): Promise<SdkworkCommentsThreadListResponse>;
      retrieve(threadId: string): Promise<SdkworkCommentsThreadSummaryResponse>;
    };
  };
  engagement: {
    targets: {
      retrieve(
        targetKind: SdkworkEngagementTargetKind,
        targetId: string,
      ): Promise<SdkworkEngagementSummaryResponse>;
    };
    visits: {
      list(params?: SdkworkEngagementVisitListRequest): Promise<SdkworkEngagementVisitListResponse>;
    };
  };
}

export interface CreateSdkworkCommentsServiceOptions {
  appClient?: SdkworkCommentsAppSdkClient;
  backendClient?: SdkworkCommentsBackendSdkClient;
}

export interface SdkworkCommentsService {
  createComment(threadId: string, request: SdkworkCommentCreateRequest): Promise<SdkworkCommentResponse>;
  deleteComment(commentId: string): Promise<SdkworkCommentDeleteResponse>;
  deleteReaction(
    commentId: string,
    reactionType: SdkworkCommentReactionType,
  ): Promise<SdkworkCommentReactionDeleteResponse>;
  ensureThread(request: SdkworkCommentsThreadEnsureRequest): Promise<SdkworkCommentsThread>;
  favoriteTarget(
    targetKind: SdkworkEngagementTargetKind,
    targetId: string,
  ): Promise<SdkworkEngagementFavoriteResponse>;
  getThreadSummary(threadId: string): Promise<SdkworkCommentsThreadSummaryResponse>;
  likeTarget(
    targetKind: SdkworkEngagementTargetKind,
    targetId: string,
  ): Promise<SdkworkEngagementReactionResponse>;
  listComments(
    threadId: string,
    request?: SdkworkCommentsListRequest,
  ): Promise<SdkworkCommentsListResponse>;
  listModerationCases(
    request?: SdkworkCommentsListRequest,
  ): Promise<SdkworkCommentModerationCaseListResponse>;
  listThreads(request?: SdkworkCommentsListRequest): Promise<SdkworkCommentsThreadListResponse>;
  listVisitHistory(
    request?: SdkworkEngagementVisitListRequest,
  ): Promise<SdkworkEngagementVisitListResponse>;
  moderateComment(
    commentId: string,
    request: SdkworkCommentModerationRequest,
  ): Promise<SdkworkCommentModerationResponse>;
  recordVisit(
    targetKind: SdkworkEngagementTargetKind,
    targetId: string,
    request?: SdkworkEngagementVisitCreateRequest,
  ): Promise<SdkworkEngagementVisitResponse>;
  summarizeTargetEngagement(
    targetKind: SdkworkEngagementTargetKind,
    targetId: string,
  ): Promise<SdkworkEngagementSummaryResponse>;
  summarizeThread(threadId: string): Promise<SdkworkCommentsThreadSummaryResponse>;
  unfavoriteTarget(
    targetKind: SdkworkEngagementTargetKind,
    targetId: string,
  ): Promise<SdkworkEngagementFavoriteDeleteResponse>;
  unlikeTarget(
    targetKind: SdkworkEngagementTargetKind,
    targetId: string,
  ): Promise<SdkworkEngagementReactionDeleteResponse>;
  updateComment(
    commentId: string,
    request: SdkworkCommentUpdateRequest,
  ): Promise<SdkworkCommentResponse>;
  upsertReaction(
    commentId: string,
    reactionType: SdkworkCommentReactionType,
  ): Promise<SdkworkCommentReactionResponse>;
}

function requireAppClient(
  appClient: SdkworkCommentsAppSdkClient | undefined,
): SdkworkCommentsAppSdkClient {
  if (!appClient) {
    throw new Error("Missing comments app SDK client");
  }
  return appClient;
}

function requireBackendClient(
  backendClient: SdkworkCommentsBackendSdkClient | undefined,
): SdkworkCommentsBackendSdkClient {
  if (!backendClient) {
    throw new Error("Missing comments backend SDK client");
  }
  return backendClient;
}

export function createSdkworkCommentsService({
  appClient,
  backendClient,
}: CreateSdkworkCommentsServiceOptions = {}): SdkworkCommentsService {
  return {
    async createComment(threadId, request) {
      return requireAppClient(appClient).comments.comments.create(threadId, {
        ...request,
        body: normalizeCommentBody(request.body),
      });
    },

    async deleteComment(commentId) {
      if (appClient) {
        await appClient.comments.comments.delete(commentId);
      } else {
        await requireBackendClient(backendClient).comments.comments.delete(commentId);
      }
      return { commentId, deleted: true };
    },

    async deleteReaction(commentId, reactionType) {
      await requireAppClient(appClient).comments.reactions.delete(commentId, reactionType);
      return { commentId, deleted: true, reactionType };
    },

    async ensureThread(request) {
      return requireAppClient(appClient).comments.threads.ensure(request);
    },

    async favoriteTarget(targetKind, targetId) {
      return requireAppClient(appClient).engagement.favorites.update(targetKind, targetId);
    },

    async getThreadSummary(threadId) {
      return this.summarizeThread(threadId);
    },

    async likeTarget(targetKind, targetId) {
      return requireAppClient(appClient).engagement.likes.update(targetKind, targetId);
    },

    async listComments(threadId, request) {
      return requireAppClient(appClient).comments.comments.list(threadId, request);
    },

    async listModerationCases(request) {
      return requireBackendClient(backendClient).comments.moderation.cases.list(request);
    },

    async listThreads(request) {
      return requireBackendClient(backendClient).comments.threads.list(request);
    },

    async listVisitHistory(request) {
      if (appClient) {
        return appClient.engagement.visits.list(request);
      }
      return requireBackendClient(backendClient).engagement.visits.list(request);
    },

    async moderateComment(commentId, request) {
      return requireBackendClient(backendClient).comments.moderation.update(commentId, request);
    },

    async recordVisit(targetKind, targetId, request = {}) {
      return requireAppClient(appClient).engagement.visits.create(targetKind, targetId, request);
    },

    async summarizeTargetEngagement(targetKind, targetId) {
      if (appClient) {
        return appClient.engagement.targets.retrieve(targetKind, targetId);
      }
      return requireBackendClient(backendClient).engagement.targets.retrieve(
        targetKind,
        targetId,
      );
    },

    async summarizeThread(threadId) {
      if (appClient) {
        return appClient.comments.threads.retrieve(threadId);
      }
      return requireBackendClient(backendClient).comments.threads.retrieve(threadId);
    },

    async unfavoriteTarget(targetKind, targetId) {
      await requireAppClient(appClient).engagement.favorites.delete(targetKind, targetId);
      return { deleted: true, targetId, targetKind };
    },

    async unlikeTarget(targetKind, targetId) {
      await requireAppClient(appClient).engagement.likes.delete(targetKind, targetId);
      return {
        deleted: true,
        reactionType: "like",
        targetId,
        targetKind,
      };
    },

    async updateComment(commentId, request) {
      return requireAppClient(appClient).comments.comments.update(commentId, {
        ...request,
        body: normalizeCommentBody(request.body),
      });
    },

    async upsertReaction(commentId, reactionType) {
      return requireAppClient(appClient).comments.reactions.update(commentId, reactionType);
    },
  };
}

export const createCommentsService = createSdkworkCommentsService;
