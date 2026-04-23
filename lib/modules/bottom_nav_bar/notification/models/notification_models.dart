class NotificationGroupCodes {
	static const String today = 'today';
	static const String yesterday = 'yesterday';
}

class NotificationFeedPayloadModel {
	final String userId;

	const NotificationFeedPayloadModel({required this.userId});

	Map<String, dynamic> toJson() {
		return <String, dynamic>{'user_id': userId};
	}
}

class NotificationItemUiModel {
	final String id;
	final String groupCode;
	final String title;
	final String message;
	final String relativeTime;
	final String iconAsset;
	final bool isUnread;

	const NotificationItemUiModel({
		required this.id,
		required this.groupCode,
		required this.title,
		required this.message,
		required this.relativeTime,
		required this.iconAsset,
		required this.isUnread,
	});

	factory NotificationItemUiModel.fromJson(Map<String, dynamic> json) {
		return NotificationItemUiModel(
			id: json['id'] as String? ?? '',
			groupCode: json['group_code'] as String? ?? '',
			title: json['title'] as String? ?? '',
			message: json['message'] as String? ?? '',
			relativeTime: json['relative_time'] as String? ?? '',
			iconAsset: json['icon_asset'] as String? ?? '',
			isUnread: json['is_unread'] as bool? ?? false,
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
			isUnread: isUnread ?? this.isUnread,
		);
	}

	Map<String, dynamic> toJson() {
		return <String, dynamic>{
			'id': id,
			'group_code': groupCode,
			'title': title,
			'message': message,
			'relative_time': relativeTime,
			'icon_asset': iconAsset,
			'is_unread': isUnread,
		};
	}
}

class NotificationFeedUiModel {
	final List<NotificationItemUiModel> notifications;

	const NotificationFeedUiModel({
		required this.notifications,
	});

	factory NotificationFeedUiModel.fromJson(Map<String, dynamic> json) {
		final items = (json['notifications'] as List<dynamic>? ?? const <dynamic>[])
				.whereType<Map<String, dynamic>>()
				.map(NotificationItemUiModel.fromJson)
				.toList(growable: false);

		return NotificationFeedUiModel(notifications: items);
	}

	Map<String, dynamic> toJson() {
		return <String, dynamic>{
			'notifications': notifications.map((item) => item.toJson()).toList(),
		};
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
			if (item.isUnread) {
				return true;
			}
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
