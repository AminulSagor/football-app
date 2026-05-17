import 'package:dio/dio.dart' as dio;

import '../../../../../core/services/api_client.dart';
import '../models/signup_models.dart';

class SignupService {
  final ApiClient _apiClient;

  SignupService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<SignupRegisterResult> register(SignupRegisterPayload payload) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/register',
      data: payload.toJson(),
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
        extra: <String, dynamic>{'skipAuth': true},
      ),
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final dataJson = responseData['data'];
    if (dataJson is! Map<String, dynamic>) {
      throw Exception('missing_data');
    }

    return SignupRegisterResult.fromJson(dataJson);
  }

  Future<SignupVerifyEmailResult> verifyEmail(
    SignupVerifyEmailPayload payload,
  ) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/verify-email',
      data: payload.toJson(),
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
        extra: <String, dynamic>{'skipAuth': true},
      ),
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final dataJson = responseData['data'];
    if (dataJson is! Map<String, dynamic>) {
      throw Exception('missing_data');
    }

    return SignupVerifyEmailResult.fromJson(dataJson);
  }

  Future<void> resendOtp(SignupResendOtpPayload payload) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/auth/resend-otp',
      data: payload.toJson(),
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
        extra: <String, dynamic>{'skipAuth': true},
      ),
    );
  }
}
