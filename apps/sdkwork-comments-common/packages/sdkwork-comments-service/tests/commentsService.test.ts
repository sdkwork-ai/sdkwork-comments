import { describe, expect, it, vi } from "vitest";
import { createSdkworkCommentsService } from "../src";
import type {
  SdkworkCommentsAppSdkClient,
  SdkworkCommentsBackendSdkClient,
} from "../src";

const comment = {
  authorId: "user-1",
  body: "A useful comment",
  createdAt: "2026-11-04T02:00:00.000Z",
  id: "comment-1",
  likeCount: 2,
  replyCount: 0,
  status: "published" as const,
  threadId: "thread-1",
};

const summary = {
  hiddenCount: 0,
  latestActivityAt: "2026-11-04T02:00:00.000Z",
  ownerId: "news-1",
  ownerKind: "news-item",
  pendingReviewCount: 0,
  publishedCount: 1,
  reactionCounts: { like: 2 },
  replyCount: 0,
  tenantId: "tenant-1",
  threadId: "thread-1",
  totalCount: 1,
};

function createAppClient() {
  return {
    comments: {
      comments: {
        create: vi.fn(async () => ({ comment })),
        delete: vi.fn(async () => undefined),
        list: vi.fn(async () => ({
          items: [comment],
          pageInfo: {
            mode: "offset" as const,
            page: 1,
            pageSize: 10,
            totalItems: 1,
            totalPages: 1,
          },
        })),
        update: vi.fn(async () => ({ comment })),
      },
      reactions: {
        delete: vi.fn(async () => undefined),
        update: vi.fn(async () => ({
          reaction: {
            commentId: "comment-1",
            createdAt: "2026-11-04T02:00:00.000Z",
            reactionType: "like" as const,
            userId: "user-1",
          },
        })),
      },
      threads: {
        ensure: vi.fn(async () => ({
          id: "thread-1",
          ownerId: "news-1",
          ownerKind: "news-item",
          tenantId: "tenant-1",
        })),
        retrieve: vi.fn(async () => ({ summary })),
      },
    },
    engagement: {
      favorites: {
        delete: vi.fn(async () => undefined),
        update: vi.fn(async () => ({
          favorite: {
            createdAt: "2026-11-04T02:00:00.000Z",
            targetId: "news-1",
            targetKind: "news-item",
            userId: "user-1",
          },
        })),
      },
      likes: {
        delete: vi.fn(async () => undefined),
        update: vi.fn(async () => ({
          reaction: {
            createdAt: "2026-11-04T02:00:00.000Z",
            reactionType: "like" as const,
            targetId: "news-1",
            targetKind: "news-item",
            userId: "user-1",
          },
        })),
      },
      targets: {
        retrieve: vi.fn(async () => ({
          summary: {
            favoriteCount: 1,
            latestActivityAt: "2026-11-04T02:00:00.000Z",
            reactionCounts: { like: 3 },
            targetId: "news-1",
            targetKind: "news-item",
            uniqueVisitorCount: 2,
            visitCount: 5,
          },
        })),
      },
      visits: {
        create: vi.fn(async () => ({
          visit: {
            createdAt: "2026-11-04T02:00:00.000Z",
            targetId: "news-1",
            targetKind: "news-item",
            userId: "user-1",
            visitId: "visit-1",
          },
        })),
        list: vi.fn(async () => ({
          items: [],
          pageInfo: {
            mode: "offset" as const,
            page: 1,
            pageSize: 20,
            totalItems: 0,
            totalPages: 1,
          },
        })),
      },
    },
  } as unknown as SdkworkCommentsAppSdkClient;
}

function createBackendClient() {
  return {
    comments: {
      comments: {
        delete: vi.fn(async () => undefined),
        list: vi.fn(),
      },
      moderation: {
        cases: {
          list: vi.fn(async () => ({
            items: [],
            pageInfo: {
              mode: "offset" as const,
              page: 1,
              pageSize: 20,
              totalItems: 0,
              totalPages: 1,
            },
          })),
        },
        update: vi.fn(async () => ({
          comment,
          moderationEvent: {
            commentId: "comment-1",
            createdAt: "2026-11-04T02:00:00.000Z",
            id: "event-1",
            status: "hidden" as const,
          },
        })),
      },
      threads: {
        list: vi.fn(),
        retrieve: vi.fn(),
      },
    },
    engagement: {
      targets: { retrieve: vi.fn() },
      visits: { list: vi.fn() },
    },
  } as unknown as SdkworkCommentsBackendSdkClient;
}

describe("@sdkwork/comments-service", () => {
  it("routes threads, comments, and reactions through generated app methods", async () => {
    const appClient = createAppClient();
    const service = createSdkworkCommentsService({ appClient });

    await expect(
      service.ensureThread({ ownerId: "news-1", ownerKind: "news-item" }),
    ).resolves.toMatchObject({ id: "thread-1" });
    await expect(service.listComments("thread-1")).resolves.toMatchObject({
      items: [{ id: "comment-1" }],
    });
    await expect(
      service.createComment("thread-1", { body: "  A useful comment  " }),
    ).resolves.toMatchObject({
      comment: { id: "comment-1" },
    });
    await expect(service.upsertReaction("comment-1", "like")).resolves.toMatchObject({
      reaction: { reactionType: "like" },
    });
    await expect(service.deleteReaction("comment-1", "like")).resolves.toEqual({
      commentId: "comment-1",
      deleted: true,
      reactionType: "like",
    });

    expect(appClient.comments.comments.create).toHaveBeenCalledWith(
      "thread-1",
      expect.objectContaining({ body: "A useful comment" }),
    );
    expect(appClient.comments.reactions.update).toHaveBeenCalledWith(
      "comment-1",
      "like",
    );
    expect(appClient.comments.reactions.delete).toHaveBeenCalledWith(
      "comment-1",
      "like",
    );
  });

  it("maps engagement likes, favorites, summaries, and visits", async () => {
    const appClient = createAppClient();
    const service = createSdkworkCommentsService({ appClient });

    await expect(service.likeTarget("news-item", "news-1")).resolves.toBeDefined();
    await expect(service.unlikeTarget("news-item", "news-1")).resolves.toEqual({
      deleted: true,
      reactionType: "like",
      targetId: "news-1",
      targetKind: "news-item",
    });
    await expect(service.favoriteTarget("news-item", "news-1")).resolves.toBeDefined();
    await expect(service.unfavoriteTarget("news-item", "news-1")).resolves.toEqual({
      deleted: true,
      targetId: "news-1",
      targetKind: "news-item",
    });
    await expect(
      service.summarizeTargetEngagement("news-item", "news-1"),
    ).resolves.toMatchObject({ summary: { visitCount: 5 } });
    await expect(service.listVisitHistory()).resolves.toMatchObject({ items: [] });

    expect(appClient.engagement.likes.update).toHaveBeenCalledWith(
      "news-item",
      "news-1",
    );
    expect(appClient.engagement.favorites.delete).toHaveBeenCalledWith(
      "news-item",
      "news-1",
    );
  });

  it("uses backend moderation methods for administrative workflows", async () => {
    const backendClient = createBackendClient();
    const service = createSdkworkCommentsService({ backendClient });

    await expect(service.listModerationCases()).resolves.toMatchObject({ items: [] });
    await expect(
      service.moderateComment("comment-1", { status: "hidden" }),
    ).resolves.toMatchObject({ comment: { id: "comment-1" } });
    await expect(service.deleteComment("comment-1")).resolves.toEqual({
      commentId: "comment-1",
      deleted: true,
    });

    expect(backendClient.comments.moderation.update).toHaveBeenCalledWith(
      "comment-1",
      { status: "hidden" },
    );
  });

  it("fails explicitly when a required generated SDK client is not injected", async () => {
    const service = createSdkworkCommentsService();

    await expect(service.listComments("thread-1")).rejects.toThrow(
      "Missing comments app SDK client",
    );
    await expect(service.likeTarget("news-item", "news-1")).rejects.toThrow(
      "Missing comments app SDK client",
    );
    await expect(service.listVisitHistory()).rejects.toThrow(
      "Missing comments backend SDK client",
    );
    await expect(
      service.moderateComment("comment-1", { status: "hidden" }),
    ).rejects.toThrow("Missing comments backend SDK client");
  });
});
