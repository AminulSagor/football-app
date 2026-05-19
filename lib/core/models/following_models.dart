enum FollowEntityType { league, player, team, coach, match }

extension FollowEntityTypeApiValue on FollowEntityType {
  String get apiValue {
    switch (this) {
      case FollowEntityType.league:
        return 'LEAGUE';
      case FollowEntityType.player:
        return 'PLAYER';
      case FollowEntityType.team:
        return 'TEAM';
      case FollowEntityType.coach:
        return 'COACH';
      case FollowEntityType.match:
        return 'FIXTURE';
    }
  }
}

class FollowEntityPayloadModel {
  final FollowEntityType entityType;
  final String entityId;
  final String? installationId;
  final String? entityName;
  final String? entityLogo;
  final bool? notificationEnabled;
  final Map<String, dynamic>? metadata;

  const FollowEntityPayloadModel({
    required this.entityType,
    required this.entityId,
    this.installationId,
    this.entityName,
    this.entityLogo,
    this.notificationEnabled,
    this.metadata,
  });

  FollowEntityPayloadModel copyWith({
    FollowEntityType? entityType,
    String? entityId,
    String? installationId,
    String? entityName,
    String? entityLogo,
    bool? notificationEnabled,
    Map<String, dynamic>? metadata,
  }) {
    return FollowEntityPayloadModel(
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      installationId: installationId ?? this.installationId,
      entityName: entityName ?? this.entityName,
      entityLogo: entityLogo ?? this.entityLogo,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'entityType': entityType.apiValue,
      'entityId': entityId,
    };

    if (installationId != null && installationId!.trim().isNotEmpty) {
      payload['installationId'] = installationId;
    }
    if (entityName != null && entityName!.trim().isNotEmpty) {
      payload['entityName'] = entityName;
    }
    if (entityLogo != null && entityLogo!.trim().isNotEmpty) {
      payload['entityLogo'] = entityLogo;
    }
    if (notificationEnabled != null) {
      payload['notificationEnabled'] = notificationEnabled;
    }
    if (metadata != null && metadata!.isNotEmpty) {
      payload['metadata'] = metadata;
    }

    return payload;
  }
}

class FollowListPayloadModel {
  final String? installationId;

  const FollowListPayloadModel({this.installationId});

  FollowListPayloadModel copyWith({String? installationId}) {
    return FollowListPayloadModel(
      installationId: installationId ?? this.installationId,
    );
  }

  Map<String, dynamic> toQuery() {
    final payload = <String, dynamic>{};
    if (installationId != null && installationId!.trim().isNotEmpty) {
      payload['installationId'] = installationId;
    }
    return payload;
  }
}

class FollowStatusPayloadModel {
  final FollowEntityType entityType;
  final String entityId;
  final String? installationId;

  const FollowStatusPayloadModel({
    required this.entityType,
    required this.entityId,
    this.installationId,
  });

  FollowStatusPayloadModel copyWith({
    FollowEntityType? entityType,
    String? entityId,
    String? installationId,
  }) {
    return FollowStatusPayloadModel(
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      installationId: installationId ?? this.installationId,
    );
  }

  Map<String, dynamic> toQuery() {
    final payload = <String, dynamic>{
      'entityType': entityType.apiValue,
      'entityId': entityId,
    };
    if (installationId != null && installationId!.trim().isNotEmpty) {
      payload['installationId'] = installationId;
    }
    return payload;
  }
}

class UnfollowPayloadModel {
  final FollowEntityType entityType;
  final String entityId;
  final String? installationId;

  const UnfollowPayloadModel({
    required this.entityType,
    required this.entityId,
    this.installationId,
  });

  UnfollowPayloadModel copyWith({
    FollowEntityType? entityType,
    String? entityId,
    String? installationId,
  }) {
    return UnfollowPayloadModel(
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      installationId: installationId ?? this.installationId,
    );
  }

  Map<String, dynamic> toQuery() {
    final payload = <String, dynamic>{};
    if (installationId != null && installationId!.trim().isNotEmpty) {
      payload['installationId'] = installationId;
    }
    return payload;
  }
}

class MergeAnonymousFollowsPayloadModel {
  final String? installationId;

  const MergeAnonymousFollowsPayloadModel({this.installationId});

  MergeAnonymousFollowsPayloadModel copyWith({String? installationId}) {
    return MergeAnonymousFollowsPayloadModel(
      installationId: installationId ?? this.installationId,
    );
  }

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{};
    if (installationId != null && installationId!.trim().isNotEmpty) {
      payload['installationId'] = installationId;
    }
    return payload;
  }
}

class FollowingActionUiModel {
  final Map<String, dynamic> raw;

  const FollowingActionUiModel({required this.raw});

  factory FollowingActionUiModel.fromJson(Map<String, dynamic> json) {
    return FollowingActionUiModel(raw: json);
  }
}

class FollowingListUiModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<FollowRecordUiModel> items;
  final String timestamp;
  final String path;

  const FollowingListUiModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.items,
    required this.timestamp,
    required this.path,
  });

  factory FollowingListUiModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['data'] as List<dynamic>? ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return FollowingListUiModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      items: itemsJson
          .map(FollowRecordUiModel.fromJson)
          .where((item) => item.entityType != null)
          .toList(growable: false),
      timestamp: json['timestamp'] as String? ?? '',
      path: json['path'] as String? ?? '',
    );
  }
}

class FollowStatusUiModel {
  final Map<String, dynamic> raw;

  const FollowStatusUiModel({required this.raw});

  factory FollowStatusUiModel.fromJson(Map<String, dynamic> json) {
    return FollowStatusUiModel(raw: json);
  }
}

class MergeAnonymousFollowsUiModel {
  final Map<String, dynamic> raw;

  const MergeAnonymousFollowsUiModel({required this.raw});

  factory MergeAnonymousFollowsUiModel.fromJson(Map<String, dynamic> json) {
    return MergeAnonymousFollowsUiModel(raw: json);
  }
}

class FollowRecordUiModel {
  final String id;
  final String? userId;
  final String? installationId;
  final String entityTypeRaw;
  final FollowEntityType? entityType;
  final String entityId;
  final FollowEntitySnapshotUiModel? entitySnapshot;
  final List<FollowMetadataItemUiModel> metadataItems;
  final bool notificationEnabled;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  const FollowRecordUiModel({
    required this.id,
    required this.userId,
    required this.installationId,
    required this.entityTypeRaw,
    required this.entityType,
    required this.entityId,
    required this.entitySnapshot,
    required this.metadataItems,
    required this.notificationEnabled,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FollowRecordUiModel.fromJson(Map<String, dynamic> json) {
    final metadataJson =
        (json['metadataItems'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .toList(growable: false);

    final snapshotJson = json['entitySnapshot'] is Map<String, dynamic>
        ? json['entitySnapshot'] as Map<String, dynamic>
        : null;

    final entityTypeRaw = json['entityType'] as String? ?? '';

    return FollowRecordUiModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String?,
      installationId: json['installationId'] as String?,
      entityTypeRaw: entityTypeRaw,
      entityType: _parseFollowEntityType(entityTypeRaw),
      entityId: json['entityId'] as String? ?? '',
      entitySnapshot: snapshotJson == null
          ? null
          : FollowEntitySnapshotUiModel.fromJson(snapshotJson),
      metadataItems: metadataJson
          .map(FollowMetadataItemUiModel.fromJson)
          .toList(growable: false),
      notificationEnabled: json['notificationEnabled'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  static FollowEntityType? _parseFollowEntityType(String value) {
    switch (value) {
      case 'LEAGUE':
        return FollowEntityType.league;
      case 'PLAYER':
        return FollowEntityType.player;
      case 'TEAM':
        return FollowEntityType.team;
      case 'COACH':
        return FollowEntityType.coach;
      case 'FIXTURE':
        return FollowEntityType.match;
    }
    return null;
  }
}

class FollowEntitySnapshotUiModel {
  final String id;
  final String followId;
  final String entityName;
  final String entityLogo;
  final String createdAt;
  final String updatedAt;

  const FollowEntitySnapshotUiModel({
    required this.id,
    required this.followId,
    required this.entityName,
    required this.entityLogo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FollowEntitySnapshotUiModel.fromJson(Map<String, dynamic> json) {
    return FollowEntitySnapshotUiModel(
      id: json['id'] as String? ?? '',
      followId: json['followId'] as String? ?? '',
      entityName: json['entityName'] as String? ?? '',
      entityLogo: json['entityLogo'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}

class FollowMetadataItemUiModel {
  final String id;
  final String followId;
  final String key;
  final String value;
  final String createdAt;

  const FollowMetadataItemUiModel({
    required this.id,
    required this.followId,
    required this.key,
    required this.value,
    required this.createdAt,
  });

  factory FollowMetadataItemUiModel.fromJson(Map<String, dynamic> json) {
    return FollowMetadataItemUiModel(
      id: json['id'] as String? ?? '',
      followId: json['followId'] as String? ?? '',
      key: json['key'] as String? ?? '',
      value: json['value'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}
