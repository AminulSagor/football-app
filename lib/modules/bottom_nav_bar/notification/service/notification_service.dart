import '../models/notification_models.dart';

class NotificationService {
	Future<NotificationFeedUiModel> fetchNotifications(
		NotificationFeedPayloadModel payload,
	) async {
		await Future<void>.delayed(const Duration(milliseconds: 220));

		final payloadJson = payload.toJson();
		final userId = payloadJson['user_id'] as String? ?? '';
		if (userId.isEmpty) {
			return const NotificationFeedUiModel(
				notifications: <NotificationItemUiModel>[],
			);
		}

		return NotificationFeedUiModel.fromJson(_mockResponseJson());
	}

	Map<String, dynamic> _mockResponseJson() {
		return <String, dynamic>{
			'notifications': <Map<String, dynamic>>[
				<String, dynamic>{
					'id': 'goal-arsenal-45',
					'group_code': NotificationGroupCodes.today,
					'title': 'GOAL! Arsenal',
					'message':
							'Arsenal 1 - 0 Man City. Bukayo Saka scores in the 45th minute!',
					'relative_time': '2m ago',
					'icon_asset': 'assets/images/Overlay (1).png',
					'is_unread': true,
				},
				<String, dynamic>{
					'id': 'xi-ronaldo',
					'group_code': NotificationGroupCodes.today,
					'title': 'Starting XI: Cristiano Ronaldo',
					'message':
							'Ronaldo is in the starting lineup for Al Nassr vs Al Hilal. Match kicks off in 15 mins.',
					'relative_time': '15m ago',
					'icon_asset': 'assets/avatars/default.png',
					'is_unread': false,
				},
				<String, dynamic>{
					'id': 'matchweek-roundup',
					'group_code': NotificationGroupCodes.yesterday,
					'title': 'Matchweek 10 Roundup',
					'message':
							'Check out the latest standings and highlights from an action-packed Premier League weekend.',
					'relative_time': '1d ago',
					'icon_asset': 'assets/images/Overlay (3).png',
					'is_unread': false,
				},
				<String, dynamic>{
					'id': 'transfer-real',
					'group_code': NotificationGroupCodes.yesterday,
					'title': 'Transfer Update',
					'message': 'Real Madrid has officially announced the signing of a new midfielder.',
					'relative_time': '1d ago',
					'icon_asset': 'assets/images/Overlay (2).png',
					'is_unread': false,
				},
			],
		};
	}
}
