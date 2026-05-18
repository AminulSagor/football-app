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
  final Map<String, dynamic> raw;

  const FollowingListUiModel({required this.raw});

  factory FollowingListUiModel.fromJson(Map<String, dynamic> json) {
    return FollowingListUiModel(raw: json);
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
