import 'dart:async';

import 'package:get/get.dart';

import '../../../core/services/api_client.dart';
import '../../../core/services/api_error_handler.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';
import '../../leagues/model/leagues_models.dart';
import '../../news/model/news_model.dart';
import '../../news/news_controller.dart';
import '../../news/news_details_view.dart';
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

  Future<void> reload({bool showLoading = true}) async {
    await _loadNotifications(showLoading: showLoading);
  }

  Future<void> refreshOnOpen() async {
    await _loadNotifications(showLoading: state.value.notifications.isEmpty);
  }

  void openNotification(NotificationItemUiModel item) {
    unawaited(markOneAsRead(item.id));
    _navigateToEntity(item);
  }

  Future<void> markOneAsRead(String notificationId) async {
    final cleanId = notificationId.trim();

    if (cleanId.isEmpty) {
      return;
    }

    final current = state.value;
    var shouldCallApi = false;

    final nextItems = current.notifications
        .map((item) {
          if (item.id == cleanId && item.isUnread) {
            shouldCallApi = true;
            return item.copyWith(isUnread: false);
          }
          return item;
        })
        .toList(growable: false);

    if (!shouldCallApi) {
      return;
    }

    state.value = current.copyWith(notifications: nextItems);

    final response = await ApiErrorHandler.handle<void>(
      () => _service.markNotificationAsRead(cleanId),
      fallbackErrorCode: 'notification_mark_read_failed',
      userMessage: 'Could not mark this notification as read.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success) {
      state.value = state.value.copyWith(notifications: current.notifications);
    }
  }

  Future<void> markAllAsRead() async {
    final current = state.value;

    if (!current.hasUnread) {
      return;
    }

    final nextItems = current.notifications
        .map((item) => item.copyWith(isUnread: false))
        .toList(growable: false);

    state.value = current.copyWith(notifications: nextItems);

    final response = await ApiErrorHandler.handle<void>(
      _service.markAllAsRead,
      fallbackErrorCode: 'notifications_mark_all_read_failed',
      userMessage: 'Could not mark all notifications as read.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success) {
      state.value = state.value.copyWith(notifications: current.notifications);
    }
  }

  void _navigateToEntity(NotificationItemUiModel item) {
    final entityId = item.entityId.trim();
    if (entityId.isEmpty) {
      return;
    }

    switch (item.entityType.trim().toUpperCase()) {
      case 'FIXTURE':
        Get.toNamed(
          AppRoutes.matchDetails,
          arguments: <String, dynamic>{'fixtureId': entityId, 'id': entityId},
        );
        return;
      case 'TEAM':
        Get.toNamed(
          AppRoutes.teamProfile,
          arguments: <String, dynamic>{'teamId': entityId, 'id': entityId},
        );
        return;
      case 'NEWS':
        _openNewsDetails(entityId);
        return;
      case 'LEAGUE':
        Get.toNamed(
          AppRoutes.leagueDetails,
          arguments: <String, dynamic>{
            'league': LeaguesTopLeagueUiModel(
              leagueId: entityId,
              image: '',
              leagueName: 'League',
              badgeSeed: 'LG',
              badgeHex: '#2A3B36',
            ),
          },
        );
        return;
      case 'PLAYER':
        Get.toNamed(
          AppRoutes.playerProfile,
          arguments: <String, dynamic>{'playerId': entityId, 'id': entityId},
        );
        return;
      default:
        return;
    }
  }

  void _openNewsDetails(String entityId) {
    if (!Get.isRegistered<NewsController>()) {
      NewsBinding().dependencies();
    }

    final article = NewsArticleUiModel(
      id: entityId,
      uuid: entityId,
      image: 'assets/images/Background (1).png',
      imageUrl: '',
      title: 'Loading news...',
      description: '',
      snippet: '',
      url: '',
      source: '',
      sourceSeed: 'NW',
      publishedAt: null,
      categories: const <String>[],
    );

    final newsController = Get.find<NewsController>();
    unawaited(newsController.openArticle(article));
    Get.to(() => NewsDetailsView(article: article));
  }

  Future<void> _loadNotifications({bool showLoading = true}) async {
    state.value = state.value.copyWith(
      isLoading: showLoading,
      errorCode: null,
    );

    final response = await ApiErrorHandler.handle<NotificationFeedUiModel>(
      () => _service.fetchNotifications(
        const NotificationFeedPayloadModel(page: 1, limit: 20),
      ),
      fallbackErrorCode: 'notifications_fetch_failed',
      userMessage: 'Unable to load notifications right now.',
    );

    if (isClosed) {
      return;
    }

    if (!response.success || response.data == null) {
      state.value = showLoading
          ? state.value.copyWith(
              isLoading: false,
              notifications: const <NotificationItemUiModel>[],
              errorCode: response.errorCode,
            )
          : state.value.copyWith(isLoading: false, errorCode: null);
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
      Get.lazyPut<NotificationService>(
        () => NotificationService(
          apiClient: Get.find<ApiClient>(),
          storageService: Get.find<StorageService>(),
        ),
        fenix: true,
      );
    }

    if (!Get.isRegistered<NotificationController>()) {
      Get.lazyPut<NotificationController>(
        () => NotificationController(service: Get.find<NotificationService>()),
      );
    }
  }
}
