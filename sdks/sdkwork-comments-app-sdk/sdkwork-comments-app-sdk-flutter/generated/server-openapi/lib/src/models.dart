Map<String, dynamic>? _sdkworkAsMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
  return null;
}

List<dynamic>? _sdkworkAsList(dynamic value) {
  return value is List ? value : null;
}

class ProblemDetail {
  final String type;
  final String title;
  final int status;
  final String? detail;
  final String? instance;
  final int code;
  final String traceId;
  final String? i18nKey;
  final String? locale;
  final List<FieldError>? errors;

  ProblemDetail({
    required this.type,
    required this.title,
    required this.status,
    this.detail,
    this.instance,
    required this.code,
    required this.traceId,
    this.i18nKey,
    this.locale,
    this.errors
  });

  factory ProblemDetail.fromJson(Map<String, dynamic> json) {
    return ProblemDetail(
      type: (() {
        final value = json['type']?.toString();
        if (value == null) {
          throw FormatException('ProblemDetail.type is required');
        }
        return value;
      })(),
      title: (() {
        final value = json['title']?.toString();
        if (value == null) {
          throw FormatException('ProblemDetail.title is required');
        }
        return value;
      })(),
      status: (() {
        final value = json['status'];
        if (value is! int) {
          throw FormatException('ProblemDetail.status is required');
        }
        return value;
      })(),
      detail: json['detail']?.toString(),
      instance: json['instance']?.toString(),
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('ProblemDetail.code is required');
        }
        return value;
      })(),
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('ProblemDetail.traceId is required');
        }
        return value;
      })(),
      i18nKey: json['i18nKey']?.toString(),
      locale: json['locale']?.toString(),
      errors: (() {
        final list = _sdkworkAsList(json['errors']);
        if (list == null) {
          return null;
        }
        return list
            .map((item) => (() {
        final map = _sdkworkAsMap(item);
        return map == null ? null : FieldError.fromJson(map);
      })())
            .whereType<FieldError>()
            .toList();
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type,
      'title': title,
      'status': status,
      'detail': detail,
      'instance': instance,
      'code': code,
      'traceId': traceId,
      'i18nKey': i18nKey,
      'locale': locale,
      'errors': errors?.map((item) => item.toJson()).toList(),
    };
  }
}

class FieldError {
  final String field;
  final String message;
  final int? code;
  final String? i18nKey;
  final Map<String, dynamic>? params;

  FieldError({
    required this.field,
    required this.message,
    this.code,
    this.i18nKey,
    this.params
  });

  factory FieldError.fromJson(Map<String, dynamic> json) {
    return FieldError(
      field: (() {
        final value = json['field']?.toString();
        if (value == null) {
          throw FormatException('FieldError.field is required');
        }
        return value;
      })(),
      message: (() {
        final value = json['message']?.toString();
        if (value == null) {
          throw FormatException('FieldError.message is required');
        }
        return value;
      })(),
      code: json['code'] is int ? json['code'] : null,
      i18nKey: json['i18nKey']?.toString(),
      params: (() {
        final map = _sdkworkAsMap(json['params']);
        if (map == null) {
          return null;
        }
        final result = <String, String>{};
        map.forEach((key, item) {
          final deserialized = item?.toString();
          if (deserialized is String) {
            result[key] = deserialized;
          }
        });
        return result;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'field': field,
      'message': message,
      'code': code,
      'i18nKey': i18nKey,
      'params': params?.map((key, item) => MapEntry(key, item)),
    };
  }
}

class CommentsThread {
  final String id;
  final String tenantId;
  final String ownerId;
  final String ownerKind;
  final String? title;
  final bool? locked;
  final String? closedAt;

  CommentsThread({
    required this.id,
    required this.tenantId,
    required this.ownerId,
    required this.ownerKind,
    this.title,
    this.locked,
    this.closedAt
  });

  factory CommentsThread.fromJson(Map<String, dynamic> json) {
    return CommentsThread(
      id: (() {
        final value = json['id']?.toString();
        if (value == null) {
          throw FormatException('CommentsThread.id is required');
        }
        return value;
      })(),
      tenantId: (() {
        final value = json['tenantId']?.toString();
        if (value == null) {
          throw FormatException('CommentsThread.tenantId is required');
        }
        return value;
      })(),
      ownerId: (() {
        final value = json['ownerId']?.toString();
        if (value == null) {
          throw FormatException('CommentsThread.ownerId is required');
        }
        return value;
      })(),
      ownerKind: (() {
        final value = json['ownerKind']?.toString();
        if (value == null) {
          throw FormatException('CommentsThread.ownerKind is required');
        }
        return value;
      })(),
      title: json['title']?.toString(),
      locked: json['locked'] is bool ? json['locked'] : null,
      closedAt: json['closedAt']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'tenantId': tenantId,
      'ownerId': ownerId,
      'ownerKind': ownerKind,
      'title': title,
      'locked': locked,
      'closedAt': closedAt,
    };
  }
}

class CommentQuote {
  final String id;
  final String authorId;
  final String? authorName;
  final String body;
  final String? createdAt;

  CommentQuote({
    required this.id,
    required this.authorId,
    this.authorName,
    required this.body,
    this.createdAt
  });

  factory CommentQuote.fromJson(Map<String, dynamic> json) {
    return CommentQuote(
      id: (() {
        final value = json['id']?.toString();
        if (value == null) {
          throw FormatException('CommentQuote.id is required');
        }
        return value;
      })(),
      authorId: (() {
        final value = json['authorId']?.toString();
        if (value == null) {
          throw FormatException('CommentQuote.authorId is required');
        }
        return value;
      })(),
      authorName: json['authorName']?.toString(),
      body: (() {
        final value = json['body']?.toString();
        if (value == null) {
          throw FormatException('CommentQuote.body is required');
        }
        return value;
      })(),
      createdAt: json['createdAt']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'body': body,
      'createdAt': createdAt,
    };
  }
}

class Comment {
  final String id;
  final String threadId;
  final String? parentId;
  final String? rootId;
  final String? quoteId;
  final String? authorName;
  final String? authorAvatarUrl;
  final int? replyCount;
  final int? likeCount;
  final bool? viewerLiked;
  final int? rating;
  final Map<String, dynamic>? metadata;
  final String? editedAt;
  final CommentQuote? quote;
  final String authorId;
  final String body;
  final String status;
  final String createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Comment({
    required this.id,
    required this.threadId,
    this.parentId,
    this.rootId,
    this.quoteId,
    this.authorName,
    this.authorAvatarUrl,
    this.replyCount,
    this.likeCount,
    this.viewerLiked,
    this.rating,
    this.metadata,
    this.editedAt,
    this.quote,
    required this.authorId,
    required this.body,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: (() {
        final value = json['id']?.toString();
        if (value == null) {
          throw FormatException('Comment.id is required');
        }
        return value;
      })(),
      threadId: (() {
        final value = json['threadId']?.toString();
        if (value == null) {
          throw FormatException('Comment.threadId is required');
        }
        return value;
      })(),
      parentId: json['parentId']?.toString(),
      rootId: json['rootId']?.toString(),
      quoteId: json['quoteId']?.toString(),
      authorName: json['authorName']?.toString(),
      authorAvatarUrl: json['authorAvatarUrl']?.toString(),
      replyCount: json['replyCount'] is int ? json['replyCount'] : null,
      likeCount: json['likeCount'] is int ? json['likeCount'] : null,
      viewerLiked: json['viewerLiked'] is bool ? json['viewerLiked'] : null,
      rating: json['rating'] is int ? json['rating'] : null,
      metadata: _sdkworkAsMap(json['metadata']),
      editedAt: json['editedAt']?.toString(),
      quote: (() {
        final map = _sdkworkAsMap(json['quote']);
        return map == null ? null : CommentQuote.fromJson(map);
      })(),
      authorId: (() {
        final value = json['authorId']?.toString();
        if (value == null) {
          throw FormatException('Comment.authorId is required');
        }
        return value;
      })(),
      body: (() {
        final value = json['body']?.toString();
        if (value == null) {
          throw FormatException('Comment.body is required');
        }
        return value;
      })(),
      status: (() {
        final value = json['status']?.toString();
        if (value == null) {
          throw FormatException('Comment.status is required');
        }
        return value;
      })(),
      createdAt: (() {
        final value = json['createdAt']?.toString();
        if (value == null) {
          throw FormatException('Comment.createdAt is required');
        }
        return value;
      })(),
      updatedAt: json['updatedAt']?.toString(),
      deletedAt: json['deletedAt']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'threadId': threadId,
      'parentId': parentId,
      'rootId': rootId,
      'quoteId': quoteId,
      'authorName': authorName,
      'authorAvatarUrl': authorAvatarUrl,
      'replyCount': replyCount,
      'likeCount': likeCount,
      'viewerLiked': viewerLiked,
      'rating': rating,
      'metadata': metadata,
      'editedAt': editedAt,
      'quote': quote?.toJson(),
      'authorId': authorId,
      'body': body,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}

class CommentReaction {
  final String commentId;
  final String userId;
  final String reactionType;
  final String createdAt;

  CommentReaction({
    required this.commentId,
    required this.userId,
    required this.reactionType,
    required this.createdAt
  });

  factory CommentReaction.fromJson(Map<String, dynamic> json) {
    return CommentReaction(
      commentId: (() {
        final value = json['commentId']?.toString();
        if (value == null) {
          throw FormatException('CommentReaction.commentId is required');
        }
        return value;
      })(),
      userId: (() {
        final value = json['userId']?.toString();
        if (value == null) {
          throw FormatException('CommentReaction.userId is required');
        }
        return value;
      })(),
      reactionType: (() {
        final value = json['reactionType']?.toString();
        if (value == null) {
          throw FormatException('CommentReaction.reactionType is required');
        }
        return value;
      })(),
      createdAt: (() {
        final value = json['createdAt']?.toString();
        if (value == null) {
          throw FormatException('CommentReaction.createdAt is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'commentId': commentId,
      'userId': userId,
      'reactionType': reactionType,
      'createdAt': createdAt,
    };
  }
}

class EngagementReaction {
  final String targetKind;
  final String targetId;
  final String userId;
  final String reactionType;
  final String createdAt;

  EngagementReaction({
    required this.targetKind,
    required this.targetId,
    required this.userId,
    required this.reactionType,
    required this.createdAt
  });

  factory EngagementReaction.fromJson(Map<String, dynamic> json) {
    return EngagementReaction(
      targetKind: (() {
        final value = json['targetKind']?.toString();
        if (value == null) {
          throw FormatException('EngagementReaction.targetKind is required');
        }
        return value;
      })(),
      targetId: (() {
        final value = json['targetId']?.toString();
        if (value == null) {
          throw FormatException('EngagementReaction.targetId is required');
        }
        return value;
      })(),
      userId: (() {
        final value = json['userId']?.toString();
        if (value == null) {
          throw FormatException('EngagementReaction.userId is required');
        }
        return value;
      })(),
      reactionType: (() {
        final value = json['reactionType']?.toString();
        if (value == null) {
          throw FormatException('EngagementReaction.reactionType is required');
        }
        return value;
      })(),
      createdAt: (() {
        final value = json['createdAt']?.toString();
        if (value == null) {
          throw FormatException('EngagementReaction.createdAt is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'targetKind': targetKind,
      'targetId': targetId,
      'userId': userId,
      'reactionType': reactionType,
      'createdAt': createdAt,
    };
  }
}

class EngagementFavorite {
  final String targetKind;
  final String targetId;
  final String userId;
  final String createdAt;

  EngagementFavorite({
    required this.targetKind,
    required this.targetId,
    required this.userId,
    required this.createdAt
  });

  factory EngagementFavorite.fromJson(Map<String, dynamic> json) {
    return EngagementFavorite(
      targetKind: (() {
        final value = json['targetKind']?.toString();
        if (value == null) {
          throw FormatException('EngagementFavorite.targetKind is required');
        }
        return value;
      })(),
      targetId: (() {
        final value = json['targetId']?.toString();
        if (value == null) {
          throw FormatException('EngagementFavorite.targetId is required');
        }
        return value;
      })(),
      userId: (() {
        final value = json['userId']?.toString();
        if (value == null) {
          throw FormatException('EngagementFavorite.userId is required');
        }
        return value;
      })(),
      createdAt: (() {
        final value = json['createdAt']?.toString();
        if (value == null) {
          throw FormatException('EngagementFavorite.createdAt is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'targetKind': targetKind,
      'targetId': targetId,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}

class EngagementVisit {
  final String visitId;
  final String targetKind;
  final String targetId;
  final String userId;
  final String? source;
  final String createdAt;

  EngagementVisit({
    required this.visitId,
    required this.targetKind,
    required this.targetId,
    required this.userId,
    this.source,
    required this.createdAt
  });

  factory EngagementVisit.fromJson(Map<String, dynamic> json) {
    return EngagementVisit(
      visitId: (() {
        final value = json['visitId']?.toString();
        if (value == null) {
          throw FormatException('EngagementVisit.visitId is required');
        }
        return value;
      })(),
      targetKind: (() {
        final value = json['targetKind']?.toString();
        if (value == null) {
          throw FormatException('EngagementVisit.targetKind is required');
        }
        return value;
      })(),
      targetId: (() {
        final value = json['targetId']?.toString();
        if (value == null) {
          throw FormatException('EngagementVisit.targetId is required');
        }
        return value;
      })(),
      userId: (() {
        final value = json['userId']?.toString();
        if (value == null) {
          throw FormatException('EngagementVisit.userId is required');
        }
        return value;
      })(),
      source: json['source']?.toString(),
      createdAt: (() {
        final value = json['createdAt']?.toString();
        if (value == null) {
          throw FormatException('EngagementVisit.createdAt is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'visitId': visitId,
      'targetKind': targetKind,
      'targetId': targetId,
      'userId': userId,
      'source': source,
      'createdAt': createdAt,
    };
  }
}

class CommentReactionCounts {
  final int? dislike;
  final int? flag;
  final int? heart;
  final int? like;

  CommentReactionCounts({
    this.dislike,
    this.flag,
    this.heart,
    this.like
  });

  factory CommentReactionCounts.fromJson(Map<String, dynamic> json) {
    return CommentReactionCounts(
      dislike: json['dislike'] is int ? json['dislike'] : null,
      flag: json['flag'] is int ? json['flag'] : null,
      heart: json['heart'] is int ? json['heart'] : null,
      like: json['like'] is int ? json['like'] : null
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'dislike': dislike,
      'flag': flag,
      'heart': heart,
      'like': like,
    };
  }
}

class EngagementSummary {
  final String targetKind;
  final String targetId;
  final CommentReactionCounts reactionCounts;
  final int favoriteCount;
  final int visitCount;
  final int uniqueVisitorCount;
  final String latestActivityAt;

  EngagementSummary({
    required this.targetKind,
    required this.targetId,
    required this.reactionCounts,
    required this.favoriteCount,
    required this.visitCount,
    required this.uniqueVisitorCount,
    required this.latestActivityAt
  });

  factory EngagementSummary.fromJson(Map<String, dynamic> json) {
    return EngagementSummary(
      targetKind: (() {
        final value = json['targetKind']?.toString();
        if (value == null) {
          throw FormatException('EngagementSummary.targetKind is required');
        }
        return value;
      })(),
      targetId: (() {
        final value = json['targetId']?.toString();
        if (value == null) {
          throw FormatException('EngagementSummary.targetId is required');
        }
        return value;
      })(),
      reactionCounts: (() {
        final map = _sdkworkAsMap(json['reactionCounts']);
        if (map == null) {
          throw FormatException('EngagementSummary.reactionCounts is required');
        }
        return CommentReactionCounts.fromJson(map);
      })(),
      favoriteCount: (() {
        final value = json['favoriteCount'];
        if (value is! int) {
          throw FormatException('EngagementSummary.favoriteCount is required');
        }
        return value;
      })(),
      visitCount: (() {
        final value = json['visitCount'];
        if (value is! int) {
          throw FormatException('EngagementSummary.visitCount is required');
        }
        return value;
      })(),
      uniqueVisitorCount: (() {
        final value = json['uniqueVisitorCount'];
        if (value is! int) {
          throw FormatException('EngagementSummary.uniqueVisitorCount is required');
        }
        return value;
      })(),
      latestActivityAt: (() {
        final value = json['latestActivityAt']?.toString();
        if (value == null) {
          throw FormatException('EngagementSummary.latestActivityAt is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'targetKind': targetKind,
      'targetId': targetId,
      'reactionCounts': reactionCounts.toJson(),
      'favoriteCount': favoriteCount,
      'visitCount': visitCount,
      'uniqueVisitorCount': uniqueVisitorCount,
      'latestActivityAt': latestActivityAt,
    };
  }
}

class CommentsThreadSummary {
  final String threadId;
  final String tenantId;
  final String ownerId;
  final String ownerKind;
  final String? title;
  final int totalCount;
  final int publishedCount;
  final int pendingReviewCount;
  final int hiddenCount;
  final int replyCount;
  final double? averageRating;
  final int? ratingCount;
  final CommentReactionCounts reactionCounts;
  final String latestActivityAt;

  CommentsThreadSummary({
    required this.threadId,
    required this.tenantId,
    required this.ownerId,
    required this.ownerKind,
    this.title,
    required this.totalCount,
    required this.publishedCount,
    required this.pendingReviewCount,
    required this.hiddenCount,
    required this.replyCount,
    this.averageRating,
    this.ratingCount,
    required this.reactionCounts,
    required this.latestActivityAt
  });

  factory CommentsThreadSummary.fromJson(Map<String, dynamic> json) {
    return CommentsThreadSummary(
      threadId: (() {
        final value = json['threadId']?.toString();
        if (value == null) {
          throw FormatException('CommentsThreadSummary.threadId is required');
        }
        return value;
      })(),
      tenantId: (() {
        final value = json['tenantId']?.toString();
        if (value == null) {
          throw FormatException('CommentsThreadSummary.tenantId is required');
        }
        return value;
      })(),
      ownerId: (() {
        final value = json['ownerId']?.toString();
        if (value == null) {
          throw FormatException('CommentsThreadSummary.ownerId is required');
        }
        return value;
      })(),
      ownerKind: (() {
        final value = json['ownerKind']?.toString();
        if (value == null) {
          throw FormatException('CommentsThreadSummary.ownerKind is required');
        }
        return value;
      })(),
      title: json['title']?.toString(),
      totalCount: (() {
        final value = json['totalCount'];
        if (value is! int) {
          throw FormatException('CommentsThreadSummary.totalCount is required');
        }
        return value;
      })(),
      publishedCount: (() {
        final value = json['publishedCount'];
        if (value is! int) {
          throw FormatException('CommentsThreadSummary.publishedCount is required');
        }
        return value;
      })(),
      pendingReviewCount: (() {
        final value = json['pendingReviewCount'];
        if (value is! int) {
          throw FormatException('CommentsThreadSummary.pendingReviewCount is required');
        }
        return value;
      })(),
      hiddenCount: (() {
        final value = json['hiddenCount'];
        if (value is! int) {
          throw FormatException('CommentsThreadSummary.hiddenCount is required');
        }
        return value;
      })(),
      replyCount: (() {
        final value = json['replyCount'];
        if (value is! int) {
          throw FormatException('CommentsThreadSummary.replyCount is required');
        }
        return value;
      })(),
      averageRating: json['averageRating'] is num ? json['averageRating'].toDouble() : null,
      ratingCount: json['ratingCount'] is int ? json['ratingCount'] : null,
      reactionCounts: (() {
        final map = _sdkworkAsMap(json['reactionCounts']);
        if (map == null) {
          throw FormatException('CommentsThreadSummary.reactionCounts is required');
        }
        return CommentReactionCounts.fromJson(map);
      })(),
      latestActivityAt: (() {
        final value = json['latestActivityAt']?.toString();
        if (value == null) {
          throw FormatException('CommentsThreadSummary.latestActivityAt is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'threadId': threadId,
      'tenantId': tenantId,
      'ownerId': ownerId,
      'ownerKind': ownerKind,
      'title': title,
      'totalCount': totalCount,
      'publishedCount': publishedCount,
      'pendingReviewCount': pendingReviewCount,
      'hiddenCount': hiddenCount,
      'replyCount': replyCount,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
      'reactionCounts': reactionCounts.toJson(),
      'latestActivityAt': latestActivityAt,
    };
  }
}

class CommentsPageInfo {
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  CommentsPageInfo({
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages
  });

  factory CommentsPageInfo.fromJson(Map<String, dynamic> json) {
    return CommentsPageInfo(
      page: (() {
        final value = json['page'];
        if (value is! int) {
          throw FormatException('CommentsPageInfo.page is required');
        }
        return value;
      })(),
      pageSize: (() {
        final value = json['pageSize'];
        if (value is! int) {
          throw FormatException('CommentsPageInfo.pageSize is required');
        }
        return value;
      })(),
      totalItems: (() {
        final value = json['totalItems'];
        if (value is! int) {
          throw FormatException('CommentsPageInfo.totalItems is required');
        }
        return value;
      })(),
      totalPages: (() {
        final value = json['totalPages'];
        if (value is! int) {
          throw FormatException('CommentsPageInfo.totalPages is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
      'totalItems': totalItems,
      'totalPages': totalPages,
    };
  }
}

class CommentCreateRequest {
  final String body;
  final String? parentId;
  final String? quoteId;
  final String? authorName;
  final String? authorAvatarUrl;
  final int? rating;
  final Map<String, dynamic>? metadata;

  CommentCreateRequest({
    required this.body,
    this.parentId,
    this.quoteId,
    this.authorName,
    this.authorAvatarUrl,
    this.rating,
    this.metadata
  });

  factory CommentCreateRequest.fromJson(Map<String, dynamic> json) {
    return CommentCreateRequest(
      body: (() {
        final value = json['body']?.toString();
        if (value == null) {
          throw FormatException('CommentCreateRequest.body is required');
        }
        return value;
      })(),
      parentId: json['parentId']?.toString(),
      quoteId: json['quoteId']?.toString(),
      authorName: json['authorName']?.toString(),
      authorAvatarUrl: json['authorAvatarUrl']?.toString(),
      rating: json['rating'] is int ? json['rating'] : null,
      metadata: _sdkworkAsMap(json['metadata'])
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'body': body,
      'parentId': parentId,
      'quoteId': quoteId,
      'authorName': authorName,
      'authorAvatarUrl': authorAvatarUrl,
      'rating': rating,
      'metadata': metadata,
    };
  }
}

class CommentUpdateRequest {
  final String body;

  CommentUpdateRequest({
    required this.body
  });

  factory CommentUpdateRequest.fromJson(Map<String, dynamic> json) {
    return CommentUpdateRequest(
      body: (() {
        final value = json['body']?.toString();
        if (value == null) {
          throw FormatException('CommentUpdateRequest.body is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'body': body,
    };
  }
}

class CommentModerationRequest {
  final String status;
  final String? reason;

  CommentModerationRequest({
    required this.status,
    this.reason
  });

  factory CommentModerationRequest.fromJson(Map<String, dynamic> json) {
    return CommentModerationRequest(
      status: (() {
        final value = json['status']?.toString();
        if (value == null) {
          throw FormatException('CommentModerationRequest.status is required');
        }
        return value;
      })(),
      reason: json['reason']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status,
      'reason': reason,
    };
  }
}

class CommentResponse {
  final Comment comment;

  CommentResponse({
    required this.comment
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      comment: (() {
        final map = _sdkworkAsMap(json['comment']);
        if (map == null) {
          throw FormatException('CommentResponse.comment is required');
        }
        return Comment.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'comment': comment.toJson(),
    };
  }
}

class CommentDeleteResponse {
  final String commentId;
  final bool deleted;

  CommentDeleteResponse({
    required this.commentId,
    required this.deleted
  });

  factory CommentDeleteResponse.fromJson(Map<String, dynamic> json) {
    return CommentDeleteResponse(
      commentId: (() {
        final value = json['commentId']?.toString();
        if (value == null) {
          throw FormatException('CommentDeleteResponse.commentId is required');
        }
        return value;
      })(),
      deleted: (() {
        final value = json['deleted'];
        if (value is! bool) {
          throw FormatException('CommentDeleteResponse.deleted is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'commentId': commentId,
      'deleted': deleted,
    };
  }
}

class CommentReactionResponse {
  final CommentReaction reaction;

  CommentReactionResponse({
    required this.reaction
  });

  factory CommentReactionResponse.fromJson(Map<String, dynamic> json) {
    return CommentReactionResponse(
      reaction: (() {
        final map = _sdkworkAsMap(json['reaction']);
        if (map == null) {
          throw FormatException('CommentReactionResponse.reaction is required');
        }
        return CommentReaction.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'reaction': reaction.toJson(),
    };
  }
}

class CommentReactionDeleteResponse {
  final String commentId;
  final String reactionType;
  final bool deleted;

  CommentReactionDeleteResponse({
    required this.commentId,
    required this.reactionType,
    required this.deleted
  });

  factory CommentReactionDeleteResponse.fromJson(Map<String, dynamic> json) {
    return CommentReactionDeleteResponse(
      commentId: (() {
        final value = json['commentId']?.toString();
        if (value == null) {
          throw FormatException('CommentReactionDeleteResponse.commentId is required');
        }
        return value;
      })(),
      reactionType: (() {
        final value = json['reactionType']?.toString();
        if (value == null) {
          throw FormatException('CommentReactionDeleteResponse.reactionType is required');
        }
        return value;
      })(),
      deleted: (() {
        final value = json['deleted'];
        if (value is! bool) {
          throw FormatException('CommentReactionDeleteResponse.deleted is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'commentId': commentId,
      'reactionType': reactionType,
      'deleted': deleted,
    };
  }
}

class EngagementReactionResponse {
  final EngagementReaction reaction;

  EngagementReactionResponse({
    required this.reaction
  });

  factory EngagementReactionResponse.fromJson(Map<String, dynamic> json) {
    return EngagementReactionResponse(
      reaction: (() {
        final map = _sdkworkAsMap(json['reaction']);
        if (map == null) {
          throw FormatException('EngagementReactionResponse.reaction is required');
        }
        return EngagementReaction.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'reaction': reaction.toJson(),
    };
  }
}

class EngagementReactionDeleteResponse {
  final String targetKind;
  final String targetId;
  final String reactionType;
  final bool deleted;

  EngagementReactionDeleteResponse({
    required this.targetKind,
    required this.targetId,
    required this.reactionType,
    required this.deleted
  });

  factory EngagementReactionDeleteResponse.fromJson(Map<String, dynamic> json) {
    return EngagementReactionDeleteResponse(
      targetKind: (() {
        final value = json['targetKind']?.toString();
        if (value == null) {
          throw FormatException('EngagementReactionDeleteResponse.targetKind is required');
        }
        return value;
      })(),
      targetId: (() {
        final value = json['targetId']?.toString();
        if (value == null) {
          throw FormatException('EngagementReactionDeleteResponse.targetId is required');
        }
        return value;
      })(),
      reactionType: (() {
        final value = json['reactionType']?.toString();
        if (value == null) {
          throw FormatException('EngagementReactionDeleteResponse.reactionType is required');
        }
        return value;
      })(),
      deleted: (() {
        final value = json['deleted'];
        if (value is! bool) {
          throw FormatException('EngagementReactionDeleteResponse.deleted is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'targetKind': targetKind,
      'targetId': targetId,
      'reactionType': reactionType,
      'deleted': deleted,
    };
  }
}

class EngagementFavoriteResponse {
  final EngagementFavorite favorite;

  EngagementFavoriteResponse({
    required this.favorite
  });

  factory EngagementFavoriteResponse.fromJson(Map<String, dynamic> json) {
    return EngagementFavoriteResponse(
      favorite: (() {
        final map = _sdkworkAsMap(json['favorite']);
        if (map == null) {
          throw FormatException('EngagementFavoriteResponse.favorite is required');
        }
        return EngagementFavorite.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'favorite': favorite.toJson(),
    };
  }
}

class EngagementFavoriteDeleteResponse {
  final String targetKind;
  final String targetId;
  final bool deleted;

  EngagementFavoriteDeleteResponse({
    required this.targetKind,
    required this.targetId,
    required this.deleted
  });

  factory EngagementFavoriteDeleteResponse.fromJson(Map<String, dynamic> json) {
    return EngagementFavoriteDeleteResponse(
      targetKind: (() {
        final value = json['targetKind']?.toString();
        if (value == null) {
          throw FormatException('EngagementFavoriteDeleteResponse.targetKind is required');
        }
        return value;
      })(),
      targetId: (() {
        final value = json['targetId']?.toString();
        if (value == null) {
          throw FormatException('EngagementFavoriteDeleteResponse.targetId is required');
        }
        return value;
      })(),
      deleted: (() {
        final value = json['deleted'];
        if (value is! bool) {
          throw FormatException('EngagementFavoriteDeleteResponse.deleted is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'targetKind': targetKind,
      'targetId': targetId,
      'deleted': deleted,
    };
  }
}

class EngagementVisitCreateRequest {
  final String? source;

  EngagementVisitCreateRequest({
    this.source
  });

  factory EngagementVisitCreateRequest.fromJson(Map<String, dynamic> json) {
    return EngagementVisitCreateRequest(
      source: json['source']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'source': source,
    };
  }
}

class EngagementVisitResponse {
  final EngagementVisit visit;

  EngagementVisitResponse({
    required this.visit
  });

  factory EngagementVisitResponse.fromJson(Map<String, dynamic> json) {
    return EngagementVisitResponse(
      visit: (() {
        final map = _sdkworkAsMap(json['visit']);
        if (map == null) {
          throw FormatException('EngagementVisitResponse.visit is required');
        }
        return EngagementVisit.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'visit': visit.toJson(),
    };
  }
}

class EngagementSummaryResponse {
  final EngagementSummary summary;

  EngagementSummaryResponse({
    required this.summary
  });

  factory EngagementSummaryResponse.fromJson(Map<String, dynamic> json) {
    return EngagementSummaryResponse(
      summary: (() {
        final map = _sdkworkAsMap(json['summary']);
        if (map == null) {
          throw FormatException('EngagementSummaryResponse.summary is required');
        }
        return EngagementSummary.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'summary': summary.toJson(),
    };
  }
}

class CommentsListResponse {
  final List<Comment> items;
  final CommentsPageInfo pageInfo;

  CommentsListResponse({
    required this.items,
    required this.pageInfo
  });

  factory CommentsListResponse.fromJson(Map<String, dynamic> json) {
    return CommentsListResponse(
      items: (() {
        final list = _sdkworkAsList(json['items']);
        if (list == null) {
          throw FormatException('CommentsListResponse.items is required');
        }
        return list
            .map((item) => (() {
        final map = _sdkworkAsMap(item);
        return map == null ? null : Comment.fromJson(map);
      })())
            .whereType<Comment>()
            .toList();
      })(),
      pageInfo: (() {
        final map = _sdkworkAsMap(json['pageInfo']);
        if (map == null) {
          throw FormatException('CommentsListResponse.pageInfo is required');
        }
        return CommentsPageInfo.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((item) => item.toJson()).toList(),
      'pageInfo': pageInfo.toJson(),
    };
  }
}

class EngagementVisitListResponse {
  final List<EngagementVisit> items;
  final CommentsPageInfo pageInfo;

  EngagementVisitListResponse({
    required this.items,
    required this.pageInfo
  });

  factory EngagementVisitListResponse.fromJson(Map<String, dynamic> json) {
    return EngagementVisitListResponse(
      items: (() {
        final list = _sdkworkAsList(json['items']);
        if (list == null) {
          throw FormatException('EngagementVisitListResponse.items is required');
        }
        return list
            .map((item) => (() {
        final map = _sdkworkAsMap(item);
        return map == null ? null : EngagementVisit.fromJson(map);
      })())
            .whereType<EngagementVisit>()
            .toList();
      })(),
      pageInfo: (() {
        final map = _sdkworkAsMap(json['pageInfo']);
        if (map == null) {
          throw FormatException('EngagementVisitListResponse.pageInfo is required');
        }
        return CommentsPageInfo.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((item) => item.toJson()).toList(),
      'pageInfo': pageInfo.toJson(),
    };
  }
}

class CommentsThreadSummaryResponse {
  final CommentsThreadSummary summary;

  CommentsThreadSummaryResponse({
    required this.summary
  });

  factory CommentsThreadSummaryResponse.fromJson(Map<String, dynamic> json) {
    return CommentsThreadSummaryResponse(
      summary: (() {
        final map = _sdkworkAsMap(json['summary']);
        if (map == null) {
          throw FormatException('CommentsThreadSummaryResponse.summary is required');
        }
        return CommentsThreadSummary.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'summary': summary.toJson(),
    };
  }
}

class CommentsThreadListResponse {
  final List<CommentsThread> items;
  final CommentsPageInfo pageInfo;

  CommentsThreadListResponse({
    required this.items,
    required this.pageInfo
  });

  factory CommentsThreadListResponse.fromJson(Map<String, dynamic> json) {
    return CommentsThreadListResponse(
      items: (() {
        final list = _sdkworkAsList(json['items']);
        if (list == null) {
          throw FormatException('CommentsThreadListResponse.items is required');
        }
        return list
            .map((item) => (() {
        final map = _sdkworkAsMap(item);
        return map == null ? null : CommentsThread.fromJson(map);
      })())
            .whereType<CommentsThread>()
            .toList();
      })(),
      pageInfo: (() {
        final map = _sdkworkAsMap(json['pageInfo']);
        if (map == null) {
          throw FormatException('CommentsThreadListResponse.pageInfo is required');
        }
        return CommentsPageInfo.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((item) => item.toJson()).toList(),
      'pageInfo': pageInfo.toJson(),
    };
  }
}

class CommentModerationCase {
  final String id;
  final String threadId;
  final String commentId;
  final String status;
  final String? reason;
  final String createdAt;
  final String? updatedAt;

  CommentModerationCase({
    required this.id,
    required this.threadId,
    required this.commentId,
    required this.status,
    this.reason,
    required this.createdAt,
    this.updatedAt
  });

  factory CommentModerationCase.fromJson(Map<String, dynamic> json) {
    return CommentModerationCase(
      id: (() {
        final value = json['id']?.toString();
        if (value == null) {
          throw FormatException('CommentModerationCase.id is required');
        }
        return value;
      })(),
      threadId: (() {
        final value = json['threadId']?.toString();
        if (value == null) {
          throw FormatException('CommentModerationCase.threadId is required');
        }
        return value;
      })(),
      commentId: (() {
        final value = json['commentId']?.toString();
        if (value == null) {
          throw FormatException('CommentModerationCase.commentId is required');
        }
        return value;
      })(),
      status: (() {
        final value = json['status']?.toString();
        if (value == null) {
          throw FormatException('CommentModerationCase.status is required');
        }
        return value;
      })(),
      reason: json['reason']?.toString(),
      createdAt: (() {
        final value = json['createdAt']?.toString();
        if (value == null) {
          throw FormatException('CommentModerationCase.createdAt is required');
        }
        return value;
      })(),
      updatedAt: json['updatedAt']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'threadId': threadId,
      'commentId': commentId,
      'status': status,
      'reason': reason,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class CommentModerationCaseListResponse {
  final List<CommentModerationCase> items;
  final CommentsPageInfo pageInfo;

  CommentModerationCaseListResponse({
    required this.items,
    required this.pageInfo
  });

  factory CommentModerationCaseListResponse.fromJson(Map<String, dynamic> json) {
    return CommentModerationCaseListResponse(
      items: (() {
        final list = _sdkworkAsList(json['items']);
        if (list == null) {
          throw FormatException('CommentModerationCaseListResponse.items is required');
        }
        return list
            .map((item) => (() {
        final map = _sdkworkAsMap(item);
        return map == null ? null : CommentModerationCase.fromJson(map);
      })())
            .whereType<CommentModerationCase>()
            .toList();
      })(),
      pageInfo: (() {
        final map = _sdkworkAsMap(json['pageInfo']);
        if (map == null) {
          throw FormatException('CommentModerationCaseListResponse.pageInfo is required');
        }
        return CommentsPageInfo.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((item) => item.toJson()).toList(),
      'pageInfo': pageInfo.toJson(),
    };
  }
}

class CommentModerationEvent {
  final String id;
  final String commentId;
  final String actorId;
  final String status;
  final String? reason;
  final String createdAt;

  CommentModerationEvent({
    required this.id,
    required this.commentId,
    required this.actorId,
    required this.status,
    this.reason,
    required this.createdAt
  });

  factory CommentModerationEvent.fromJson(Map<String, dynamic> json) {
    return CommentModerationEvent(
      id: (() {
        final value = json['id']?.toString();
        if (value == null) {
          throw FormatException('CommentModerationEvent.id is required');
        }
        return value;
      })(),
      commentId: (() {
        final value = json['commentId']?.toString();
        if (value == null) {
          throw FormatException('CommentModerationEvent.commentId is required');
        }
        return value;
      })(),
      actorId: (() {
        final value = json['actorId']?.toString();
        if (value == null) {
          throw FormatException('CommentModerationEvent.actorId is required');
        }
        return value;
      })(),
      status: (() {
        final value = json['status']?.toString();
        if (value == null) {
          throw FormatException('CommentModerationEvent.status is required');
        }
        return value;
      })(),
      reason: json['reason']?.toString(),
      createdAt: (() {
        final value = json['createdAt']?.toString();
        if (value == null) {
          throw FormatException('CommentModerationEvent.createdAt is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'commentId': commentId,
      'actorId': actorId,
      'status': status,
      'reason': reason,
      'createdAt': createdAt,
    };
  }
}

class CommentModerationResponse {
  final Comment comment;
  final CommentModerationEvent moderationEvent;

  CommentModerationResponse({
    required this.comment,
    required this.moderationEvent
  });

  factory CommentModerationResponse.fromJson(Map<String, dynamic> json) {
    return CommentModerationResponse(
      comment: (() {
        final map = _sdkworkAsMap(json['comment']);
        if (map == null) {
          throw FormatException('CommentModerationResponse.comment is required');
        }
        return Comment.fromJson(map);
      })(),
      moderationEvent: (() {
        final map = _sdkworkAsMap(json['moderationEvent']);
        if (map == null) {
          throw FormatException('CommentModerationResponse.moderationEvent is required');
        }
        return CommentModerationEvent.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'comment': comment.toJson(),
      'moderationEvent': moderationEvent.toJson(),
    };
  }
}

class SdkWorkApiResponse {
  final int code;
  final dynamic data;
  final String traceId;

  SdkWorkApiResponse({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory SdkWorkApiResponse.fromJson(Map<String, dynamic> json) {
    return SdkWorkApiResponse(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('SdkWorkApiResponse.code is required');
        }
        return value;
      })(),
      data: json['data'],
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('SdkWorkApiResponse.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class SdkWorkResourceData {
  final Map<String, dynamic> item;

  SdkWorkResourceData({
    required this.item
  });

  factory SdkWorkResourceData.fromJson(Map<String, dynamic> json) {
    return SdkWorkResourceData(
      item: (() {
        final map = _sdkworkAsMap(json['item']);
        if (map == null) {
          throw FormatException('SdkWorkResourceData.item is required');
        }
        return map;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'item': item,
    };
  }
}

class SdkWorkPageData {
  final List<Map<String, dynamic>> items;
  final PageInfo pageInfo;

  SdkWorkPageData({
    required this.items,
    required this.pageInfo
  });

  factory SdkWorkPageData.fromJson(Map<String, dynamic> json) {
    return SdkWorkPageData(
      items: (() {
        final list = _sdkworkAsList(json['items']);
        if (list == null) {
          throw FormatException('SdkWorkPageData.items is required');
        }
        return list
            .map((item) => _sdkworkAsMap(item))
            .whereType<Map<String, dynamic>>()
            .toList();
      })(),
      pageInfo: (() {
        final map = _sdkworkAsMap(json['pageInfo']);
        if (map == null) {
          throw FormatException('SdkWorkPageData.pageInfo is required');
        }
        return PageInfo.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((item) => item).toList(),
      'pageInfo': pageInfo.toJson(),
    };
  }
}

class SdkWorkCommandData {
  final bool accepted;
  final String? resourceId;
  final String? status;

  SdkWorkCommandData({
    required this.accepted,
    this.resourceId,
    this.status
  });

  factory SdkWorkCommandData.fromJson(Map<String, dynamic> json) {
    return SdkWorkCommandData(
      accepted: (() {
        final value = json['accepted'];
        if (value is! bool) {
          throw FormatException('SdkWorkCommandData.accepted is required');
        }
        return value;
      })(),
      resourceId: json['resourceId']?.toString(),
      status: json['status']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accepted': accepted,
      'resourceId': resourceId,
      'status': status,
    };
  }
}

class PageInfo {
  final String mode;
  final int? page;
  final int? pageSize;
  final String? totalItems;
  final int? totalPages;
  final String? nextCursor;
  final bool? hasMore;

  PageInfo({
    required this.mode,
    this.page,
    this.pageSize,
    this.totalItems,
    this.totalPages,
    this.nextCursor,
    this.hasMore
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      mode: (() {
        final value = json['mode']?.toString();
        if (value == null) {
          throw FormatException('PageInfo.mode is required');
        }
        return value;
      })(),
      page: json['page'] is int ? json['page'] : null,
      pageSize: json['pageSize'] is int ? json['pageSize'] : null,
      totalItems: json['totalItems']?.toString(),
      totalPages: json['totalPages'] is int ? json['totalPages'] : null,
      nextCursor: json['nextCursor']?.toString(),
      hasMore: json['hasMore'] is bool ? json['hasMore'] : null
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'mode': mode,
      'page': page,
      'pageSize': pageSize,
      'totalItems': totalItems,
      'totalPages': totalPages,
      'nextCursor': nextCursor,
      'hasMore': hasMore,
    };
  }
}

class SdkWorkResourceResponse {
  final int code;
  final dynamic data;
  final String traceId;

  SdkWorkResourceResponse({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory SdkWorkResourceResponse.fromJson(Map<String, dynamic> json) {
    return SdkWorkResourceResponse(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('SdkWorkResourceResponse.code is required');
        }
        return value;
      })(),
      data: json['data'],
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('SdkWorkResourceResponse.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class SdkWorkListResponse {
  final int code;
  final dynamic data;
  final String traceId;

  SdkWorkListResponse({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory SdkWorkListResponse.fromJson(Map<String, dynamic> json) {
    return SdkWorkListResponse(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('SdkWorkListResponse.code is required');
        }
        return value;
      })(),
      data: json['data'],
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('SdkWorkListResponse.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class SdkWorkCommandResponse {
  final int code;
  final dynamic data;
  final String traceId;

  SdkWorkCommandResponse({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory SdkWorkCommandResponse.fromJson(Map<String, dynamic> json) {
    return SdkWorkCommandResponse(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('SdkWorkCommandResponse.code is required');
        }
        return value;
      })(),
      data: json['data'],
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('SdkWorkCommandResponse.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class CommentsThreadEnsureRequest {
  final String ownerKind;
  final String ownerId;
  final String? title;

  CommentsThreadEnsureRequest({
    required this.ownerKind,
    required this.ownerId,
    this.title
  });

  factory CommentsThreadEnsureRequest.fromJson(Map<String, dynamic> json) {
    return CommentsThreadEnsureRequest(
      ownerKind: (() {
        final value = json['ownerKind']?.toString();
        if (value == null) {
          throw FormatException('CommentsThreadEnsureRequest.ownerKind is required');
        }
        return value;
      })(),
      ownerId: (() {
        final value = json['ownerId']?.toString();
        if (value == null) {
          throw FormatException('CommentsThreadEnsureRequest.ownerId is required');
        }
        return value;
      })(),
      title: json['title']?.toString()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'ownerKind': ownerKind,
      'ownerId': ownerId,
      'title': title,
    };
  }
}

class EngagementFavoritesListResponse {
  final List<EngagementFavorite> items;
  final PageInfo pageInfo;

  EngagementFavoritesListResponse({
    required this.items,
    required this.pageInfo
  });

  factory EngagementFavoritesListResponse.fromJson(Map<String, dynamic> json) {
    return EngagementFavoritesListResponse(
      items: (() {
        final list = _sdkworkAsList(json['items']);
        if (list == null) {
          throw FormatException('EngagementFavoritesListResponse.items is required');
        }
        return list
            .map((item) => (() {
        final map = _sdkworkAsMap(item);
        return map == null ? null : EngagementFavorite.fromJson(map);
      })())
            .whereType<EngagementFavorite>()
            .toList();
      })(),
      pageInfo: (() {
        final map = _sdkworkAsMap(json['pageInfo']);
        if (map == null) {
          throw FormatException('EngagementFavoritesListResponse.pageInfo is required');
        }
        return PageInfo.fromJson(map);
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'items': items.map((item) => item.toJson()).toList(),
      'pageInfo': pageInfo.toJson(),
    };
  }
}

class CommentsThreadsRetrieveResponse {
  final int code;
  final dynamic data;
  final String traceId;

  CommentsThreadsRetrieveResponse({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory CommentsThreadsRetrieveResponse.fromJson(Map<String, dynamic> json) {
    return CommentsThreadsRetrieveResponse(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('CommentsThreadsRetrieveResponse.code is required');
        }
        return value;
      })(),
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('CommentsThreadsRetrieveResponse.data is required');
        }
        return map;
      })(),
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('CommentsThreadsRetrieveResponse.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class CommentsListGetResponse {
  final int code;
  final dynamic data;
  final String traceId;

  CommentsListGetResponse({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory CommentsListGetResponse.fromJson(Map<String, dynamic> json) {
    return CommentsListGetResponse(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('CommentsListGetResponse.code is required');
        }
        return value;
      })(),
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('CommentsListGetResponse.data is required');
        }
        return map;
      })(),
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('CommentsListGetResponse.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class CommentsCreateResponse201 {
  final int code;
  final dynamic data;
  final String traceId;

  CommentsCreateResponse201({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory CommentsCreateResponse201.fromJson(Map<String, dynamic> json) {
    return CommentsCreateResponse201(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('CommentsCreateResponse201.code is required');
        }
        return value;
      })(),
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('CommentsCreateResponse201.data is required');
        }
        return map;
      })(),
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('CommentsCreateResponse201.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class CommentsUpdateResponse {
  final int code;
  final dynamic data;
  final String traceId;

  CommentsUpdateResponse({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory CommentsUpdateResponse.fromJson(Map<String, dynamic> json) {
    return CommentsUpdateResponse(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('CommentsUpdateResponse.code is required');
        }
        return value;
      })(),
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('CommentsUpdateResponse.data is required');
        }
        return map;
      })(),
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('CommentsUpdateResponse.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class CommentsReactionsUpdateResponse {
  final int code;
  final dynamic data;
  final String traceId;

  CommentsReactionsUpdateResponse({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory CommentsReactionsUpdateResponse.fromJson(Map<String, dynamic> json) {
    return CommentsReactionsUpdateResponse(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('CommentsReactionsUpdateResponse.code is required');
        }
        return value;
      })(),
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('CommentsReactionsUpdateResponse.data is required');
        }
        return map;
      })(),
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('CommentsReactionsUpdateResponse.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class EngagementTargetsRetrieveResponse {
  final int code;
  final dynamic data;
  final String traceId;

  EngagementTargetsRetrieveResponse({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory EngagementTargetsRetrieveResponse.fromJson(Map<String, dynamic> json) {
    return EngagementTargetsRetrieveResponse(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('EngagementTargetsRetrieveResponse.code is required');
        }
        return value;
      })(),
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('EngagementTargetsRetrieveResponse.data is required');
        }
        return map;
      })(),
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('EngagementTargetsRetrieveResponse.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class EngagementLikesUpdateResponse {
  final int code;
  final dynamic data;
  final String traceId;

  EngagementLikesUpdateResponse({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory EngagementLikesUpdateResponse.fromJson(Map<String, dynamic> json) {
    return EngagementLikesUpdateResponse(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('EngagementLikesUpdateResponse.code is required');
        }
        return value;
      })(),
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('EngagementLikesUpdateResponse.data is required');
        }
        return map;
      })(),
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('EngagementLikesUpdateResponse.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class EngagementFavoritesUpdateResponse {
  final int code;
  final dynamic data;
  final String traceId;

  EngagementFavoritesUpdateResponse({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory EngagementFavoritesUpdateResponse.fromJson(Map<String, dynamic> json) {
    return EngagementFavoritesUpdateResponse(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('EngagementFavoritesUpdateResponse.code is required');
        }
        return value;
      })(),
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('EngagementFavoritesUpdateResponse.data is required');
        }
        return map;
      })(),
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('EngagementFavoritesUpdateResponse.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class EngagementVisitsCreateResponse201 {
  final int code;
  final dynamic data;
  final String traceId;

  EngagementVisitsCreateResponse201({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory EngagementVisitsCreateResponse201.fromJson(Map<String, dynamic> json) {
    return EngagementVisitsCreateResponse201(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('EngagementVisitsCreateResponse201.code is required');
        }
        return value;
      })(),
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('EngagementVisitsCreateResponse201.data is required');
        }
        return map;
      })(),
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('EngagementVisitsCreateResponse201.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class EngagementVisitsListResponse {
  final int code;
  final dynamic data;
  final String traceId;

  EngagementVisitsListResponse({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory EngagementVisitsListResponse.fromJson(Map<String, dynamic> json) {
    return EngagementVisitsListResponse(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('EngagementVisitsListResponse.code is required');
        }
        return value;
      })(),
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('EngagementVisitsListResponse.data is required');
        }
        return map;
      })(),
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('EngagementVisitsListResponse.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class CommentsThreadsEnsureResponse201 {
  final int code;
  final dynamic data;
  final String traceId;

  CommentsThreadsEnsureResponse201({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory CommentsThreadsEnsureResponse201.fromJson(Map<String, dynamic> json) {
    return CommentsThreadsEnsureResponse201(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('CommentsThreadsEnsureResponse201.code is required');
        }
        return value;
      })(),
      data: (() {
        final map = _sdkworkAsMap(json['data']);
        if (map == null) {
          throw FormatException('CommentsThreadsEnsureResponse201.data is required');
        }
        return map;
      })(),
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('CommentsThreadsEnsureResponse201.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}

class EngagementFavoritesListGetResponse {
  final int code;
  final dynamic data;
  final String traceId;

  EngagementFavoritesListGetResponse({
    required this.code,
    required this.data,
    required this.traceId
  });

  factory EngagementFavoritesListGetResponse.fromJson(Map<String, dynamic> json) {
    return EngagementFavoritesListGetResponse(
      code: (() {
        final value = json['code'];
        if (value is! int) {
          throw FormatException('EngagementFavoritesListGetResponse.code is required');
        }
        return value;
      })(),
      data: json['data'],
      traceId: (() {
        final value = json['traceId']?.toString();
        if (value == null) {
          throw FormatException('EngagementFavoritesListGetResponse.traceId is required');
        }
        return value;
      })()
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'data': data,
      'traceId': traceId,
    };
  }
}
