import 'package:dio/dio.dart' as dio;

import '../../../../../core/services/api_client.dart';
import '../models/forgot_password_models.dart';

class ForgotPasswordService {
  final ApiClient _apiClient;

  ForgotPasswordService({required ApiClient apiClient})
    : _apiClient = apiClient;

  Future<void> sendResetOtp(ForgotPasswordSendOtpPayload payload) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/forgot-password',
      data: payload.toJson(),
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
        extra: <String, dynamic>{'skipAuth': true},
      ),
    );

    _ensureSuccess(response.data, fallbackErrorCode: 'forgot_password_failed');
  }

  Future<void> resetPassword(ResetPasswordPayload payload) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/reset-password',
      data: payload.toJson(),
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
        extra: <String, dynamic>{'skipAuth': true},
      ),
    );

    _ensureSuccess(response.data, fallbackErrorCode: 'reset_password_failed');
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

      if (message is List && message.isNotEmpty) {
        final first = message.first;
        if (first is String && first.trim().isNotEmpty) {
          throw Exception(first.trim());
        }
      }

      throw Exception(fallbackErrorCode);
    }
  }
}
