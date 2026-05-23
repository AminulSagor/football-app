class NotificationGroupCodes {
  static const String today = 'today';
  static const String yesterday = 'yesterday';
  static const String earlier = 'earlier';
}

class NotificationFeedPayloadModel {
  final int page;
  final int limit;
  final String? installationId;
  final bool? isRead;

  const NotificationFeedPayloadModel({
    this.page = 1,
    this.limit = 20,
    this.installationId,
    this.isRead,
  });

  NotificationFeedPayloadModel copyWith({
    int? page,
    int? limit,
    String? installationId,
    bool? isRead,
  }) {
    return NotificationFeedPayloadModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      installationId: installationId ?? this.installationId,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toQuery() {
    final query = <String, dynamic>{'page': page, 'limit': limit};

    if (installationId != null && installationId!.trim().isNotEmpty) {
      query['installationId'] = installationId!.trim();
    }

    if (isRead != null) {
      query['isRead'] = isRead;
    }

    return query;
  }
}

class NotificationItemUiModel {
  final String id;
  final String groupCode;
  final String title;
  final String message;
  final String relativeTime;
  final String iconAsset;
  final String imageUrl;
  final bool isUnread;

  const NotificationItemUiModel({
    required this.id,
    required this.groupCode,
    required this.title,
    required this.message,
    required this.relativeTime,
    required this.iconAsset,
    required this.imageUrl,
    required this.isUnread,
  });

  factory NotificationItemUiModel.fromJson(Map<String, dynamic> json) {
    final event = json['notificationEvent'] is Map<String, dynamic>
        ? json['notificationEvent'] as Map<String, dynamic>
        : <String, dynamic>{};

    final snapshot = json['contentSnapshot'] is Map<String, dynamic>
        ? json['contentSnapshot'] as Map<String, dynamic>
        : <String, dynamic>{};

    final createdAt = _parseDate(
      _readString(json['createdAt']) ??
          _readString(snapshot['createdAt']) ??
          _readString(event['createdAt']),
    );

    final eventType = _readString(event['eventType']) ?? '';

    return NotificationItemUiModel(
      id: _readString(json['id']) ?? '',
      groupCode: _resolveGroupCode(createdAt),
      title:
          _readString(snapshot['title']) ??
          _readString(event['title']) ??
          'Notification',
      message:
          _readString(snapshot['body']) ?? _readString(event['body']) ?? '',
      relativeTime: _relativeTime(createdAt),
      iconAsset: _assetForEventType(eventType),
      imageUrl:
          _readString(snapshot['imageUrl']) ??
          _readString(event['imageUrl']) ??
          '',
      isUnread: !(_readBool(json['isRead']) ?? true),
    );
  }

  NotificationItemUiModel copyWith({bool? isUnread}) {
    return NotificationItemUiModel(
      id: id,
      groupCode: groupCode,
      title: title,
      message: message,
      relativeTime: relativeTime,
      iconAsset: iconAsset,
      imageUrl: imageUrl,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}

class NotificationFeedUiModel {
  final List<NotificationItemUiModel> notifications;

  const NotificationFeedUiModel({required this.notifications});

  factory NotificationFeedUiModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final rawItems =
        data['items'] as List<dynamic>? ??
        data['notifications'] as List<dynamic>? ??
        const <dynamic>[];

    final items = rawItems
        .whereType<Map<String, dynamic>>()
        .map(NotificationItemUiModel.fromJson)
        .toList(growable: false);

    return NotificationFeedUiModel(notifications: items);
  }
}

class NotificationViewModel {
  static const Object _unset = Object();

  final bool isLoading;
  final List<NotificationItemUiModel> notifications;
  final String? errorCode;

  const NotificationViewModel({
    this.isLoading = false,
    this.notifications = const <NotificationItemUiModel>[],
    this.errorCode,
  });

  List<NotificationItemUiModel> groupedItems(String groupCode) {
    return notifications.where((item) => item.groupCode == groupCode).toList();
  }

  bool get hasUnread {
    for (final item in notifications) {
      if (item.isUnread) return true;
    }
    return false;
  }

  NotificationViewModel copyWith({
    bool? isLoading,
    List<NotificationItemUiModel>? notifications,
    Object? errorCode = _unset,
  }) {
    return NotificationViewModel(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      errorCode: identical(errorCode, _unset)
          ? this.errorCode
          : errorCode as String?,
    );
  }
}

String? _readString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

bool? _readBool(dynamic value) {
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  return null;
}

DateTime? _parseDate(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return DateTime.tryParse(value)?.toLocal();
}

String _resolveGroupCode(DateTime? createdAt) {
  if (createdAt == null) return NotificationGroupCodes.earlier;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final itemDay = DateTime(createdAt.year, createdAt.month, createdAt.day);
  final difference = today.difference(itemDay).inDays;

  if (difference == 0) return NotificationGroupCodes.today;
  if (difference == 1) return NotificationGroupCodes.yesterday;
  return NotificationGroupCodes.earlier;
}

String _relativeTime(DateTime? createdAt) {
  if (createdAt == null) return '';

  final diff = DateTime.now().difference(createdAt);

  if (diff.inMinutes < 1) return 'now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';

  return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
}

String _assetForEventType(String eventType) {
  switch (eventType.trim().toUpperCase()) {
    case 'GOAL':
    case 'MATCH':
    case 'FIXTURE':
      return 'assets/images/Overlay (1).png';
    case 'NEWS':
      return 'assets/images/Overlay (3).png';
    case 'SYSTEM':
    default:
      return 'assets/avatars/default.png';
  }
}
