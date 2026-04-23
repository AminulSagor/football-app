import 'package:get/get.dart';

import '../../../core/services/api_error_handler.dart';
import 'models/notification_models.dart';
import 'service/notification_service.dart';

class NotificationController extends GetxController {
	final NotificationService _service;

	NotificationController({required NotificationService service})
		: _service = service;

	final Rx<NotificationViewModel> state = const NotificationViewModel().obs;

	@override
	void onInit() {
		super.onInit();
		_loadNotifications();
	}

	Future<void> reload() async {
		await _loadNotifications();
	}

	void markAllAsRead() {
		if (!state.value.hasUnread) {
			return;
		}

		final nextItems = state.value.notifications
				.map((item) => item.copyWith(isUnread: false))
				.toList(growable: false);

		state.value = state.value.copyWith(notifications: nextItems);
	}

	Future<void> _loadNotifications() async {
		state.value = state.value.copyWith(isLoading: true, errorCode: null);

		final response = await ApiErrorHandler.handle<NotificationFeedUiModel>(
			() => _service.fetchNotifications(
				const NotificationFeedPayloadModel(userId: 'kicscore-user-1'),
			),
			fallbackErrorCode: 'notifications_fetch_failed',
			userMessage: 'Unable to load notifications right now.',
		);

		if (isClosed) {
			return;
		}

		if (!response.success || response.data == null) {
			state.value = state.value.copyWith(
				isLoading: false,
				notifications: const <NotificationItemUiModel>[],
				errorCode: response.errorCode,
			);
			return;
		}

		state.value = state.value.copyWith(
			isLoading: false,
			notifications: response.data!.notifications,
			errorCode: null,
		);
	}
}

class NotificationBinding extends Bindings {
	@override
	void dependencies() {
		if (!Get.isRegistered<NotificationService>()) {
			Get.lazyPut<NotificationService>(() => NotificationService(), fenix: true);
		}

		if (!Get.isRegistered<NotificationController>()) {
			Get.lazyPut<NotificationController>(
				() => NotificationController(service: Get.find<NotificationService>()),
			);
		}
	}
}
