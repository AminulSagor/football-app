import 'package:dio/dio.dart' as dio;
import 'package:firebase_app_installations/firebase_app_installations.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/services/storage_service.dart';
import '../models/notification_models.dart';

class NotificationService {
  final ApiClient _apiClient;
  final StorageService _storageService;
  final FirebaseInstallations _installations;

  NotificationService({
    required ApiClient apiClient,
    required StorageService storageService,
    FirebaseInstallations? installations,
  }) : _apiClient = apiClient,
       _storageService = storageService,
       _installations = installations ?? FirebaseInstallations.instance;

  Future<NotificationFeedUiModel> fetchNotifications(
    NotificationFeedPayloadModel payload,
  ) async {
    final installationId = await _resolveInstallationId();

    final resolvedPayload = payload.copyWith(installationId: installationId);

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/notifications',
      queryParameters: resolvedPayload.toQuery(),
      options: dio.Options(extra: _buildAuthExtras()),
    );

    _ensureSuccess(
      response.data,
      fallbackErrorCode: 'notifications_fetch_failed',
    );

    return NotificationFeedUiModel.fromJson(_requireResponseMap(response.data));
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final cleanId = notificationId.trim();

    if (cleanId.isEmpty) {
      return;
    }

    final installationId = await _resolveInstallationId();

    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/notifications/${Uri.encodeComponent(cleanId)}/read',
      queryParameters: installationId == null
          ? null
          : <String, dynamic>{'installationId': installationId},
      options: dio.Options(extra: _buildAuthExtras()),
    );

    _ensureSuccess(
      response.data,
      fallbackErrorCode: 'notification_mark_read_failed',
    );
  }

  Future<void> markAllAsRead() async {
    final installationId = await _resolveInstallationId();

    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/notifications/read-all',
      queryParameters: installationId == null
          ? null
          : <String, dynamic>{'installationId': installationId},
      options: dio.Options(extra: _buildAuthExtras()),
    );

    _ensureSuccess(
      response.data,
      fallbackErrorCode: 'notifications_mark_all_read_failed',
    );
  }

  Map<String, dynamic> _buildAuthExtras() {
    if (_storageService.isLoggedIn) {
      return const <String, dynamic>{};
    }

    return const <String, dynamic>{'skipAuth': true};
  }

  Future<String?> _resolveInstallationId() async {
    if (_storageService.isLoggedIn) {
      return null;
    }

    final cachedInstallationId = _storageService.installationId.trim();

    if (cachedInstallationId.isNotEmpty) {
      return cachedInstallationId;
    }

    final resolvedInstallationId = await _installations.getId();
    await _storageService.setInstallationId(resolvedInstallationId);

    return resolvedInstallationId;
  }

  Map<String, dynamic> _requireResponseMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw Exception('empty_response');
    }

    return data;
  }

  void _ensureSuccess(
    Map<String, dynamic>? responseData, {
    required String fallbackErrorCode,
  }) {
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final success = responseData['success'];

    if (success is bool && !success) {
      final message = responseData['message'];

      if (message is String && message.trim().isNotEmpty) {
        throw Exception(message.trim());
      }

      throw Exception(fallbackErrorCode);
    }
  }
}
