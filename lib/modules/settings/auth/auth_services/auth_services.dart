import 'package:dio/dio.dart' as dio;

import '../../../../core/services/api_client.dart';
import '../../../../core/services/storage_service.dart';
import '../auth_models/auth_models.dart';

class SettingsAuthService {
  final ApiClient _apiClient;
  final StorageService _storageService;

  SettingsAuthService({
    required ApiClient apiClient,
    required StorageService storageService,
  }) : _apiClient = apiClient,
       _storageService = storageService;

  Future<SettingsAuthSessionUiModel?> loadSession(
    SettingsLoadSessionPayloadModel _,
  ) async {
    final token = _storageService.token;

    if (!_storageService.isLoggedIn || token.isEmpty) {
      return null;
    }

    try {
      final user = await _fetchCurrentUser();
      await _cacheUserProfile(user);

      return SettingsAuthSessionUiModel(
        token: SettingsAuthTokenUiModel(
          accessToken: token,
          tokenType: _storageService.tokenType,
          expiresIn: _storageService.tokenExpires,
        ),
        user: user,
      );
    } on dio.DioException catch (error) {
      if (error.response?.statusCode == 401) {
        await _storageService.clearLoggedInData();
        return null;
      }

      rethrow;
    }
  }

  Future<SettingsAuthSessionUiModel> signIn(
    SettingsSignInPayloadModel payload,
  ) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: payload.toJson(),
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
        extra: <String, dynamic>{'skipAuth': true},
      ),
    );

    final responseData = response.data;
    _ensureSuccess(responseData, fallbackErrorCode: 'login_failed');

    final dataJson = _readData(responseData);
    final session = SettingsAuthSessionUiModel.fromJson(dataJson);

    await _storageService.setLoggedInData(
      session.token.accessToken,
      fullName: session.user.fullName,
      email: session.user.email,
      avatarSeed: session.user.avatarSeed,
      tokenType: session.token.tokenType,
      expiresIn: session.token.expiresIn,
      userId: session.user.id,
      role: session.user.role,
    );

    return session;
  }

  Future<SettingsLogoutUiModel> logout(
    SettingsLogoutPayloadModel payload,
  ) async {
    final hadToken = payload.token.trim().isNotEmpty;

    await _storageService.clearLoggedInData();

    return SettingsLogoutUiModel.fromJson(<String, dynamic>{
      'logged_out': true,
      'had_token': hadToken,
    });
  }

  Future<SettingsProfileUpdateUiModel> updateProfile(
    SettingsProfileUpdatePayloadModel payload,
  ) async {
    var didUpdate = false;

    if (payload.hasProfileChanges) {
      final response = await _apiClient.patch<Map<String, dynamic>>(
        '/users/me/profile',
        data: payload.toProfileJson(),
        options: dio.Options(
          headers: <String, dynamic>{'Content-Type': 'application/json'},
        ),
      );

      _ensureSuccess(response.data, fallbackErrorCode: 'profile_update_failed');

      didUpdate = true;
    }

    if (payload.hasPasswordChanges) {
      final response = await _apiClient.patch<Map<String, dynamic>>(
        '/users/me/password',
        data: payload.toPasswordJson(),
        options: dio.Options(
          headers: <String, dynamic>{'Content-Type': 'application/json'},
        ),
      );

      _ensureSuccess(
        response.data,
        fallbackErrorCode: 'password_change_failed',
      );

      didUpdate = true;
    }

    final user = await _fetchCurrentUser();
    await _cacheUserProfile(user);

    return SettingsProfileUpdateUiModel(updated: didUpdate, user: user);
  }

  Future<void> updateUnits({required String unitSystem}) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/users/me/settings',
      data: <String, dynamic>{'unitSystem': unitSystem},
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    _ensureSuccess(
      response.data,
      fallbackErrorCode: 'unit_settings_update_failed',
    );
  }

  Future<void> updateMatchAlertsPreference({required bool enabled}) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/notifications/preferences/match-alerts',
      data: <String, dynamic>{'matchAlertsEnabled': enabled},
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    _ensureSuccess(
      response.data,
      fallbackErrorCode: 'match_alerts_update_failed',
    );
  }

  Future<SettingsDeleteAccountUiModel> deleteAccount(
    SettingsDeleteAccountPayloadModel payload,
  ) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/users/me/delete-account',
      data: payload.toJson(),
      options: dio.Options(
        headers: <String, dynamic>{'Content-Type': 'application/json'},
      ),
    );

    _ensureSuccess(response.data, fallbackErrorCode: 'delete_account_failed');

    await _storageService.clearLoggedInData();

    return SettingsDeleteAccountUiModel.fromJson(<String, dynamic>{
      'deleted': true,
    });
  }

  Future<SettingsUserUiModel> _fetchCurrentUser() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/users/me');

    final responseData = response.data;
    _ensureSuccess(responseData, fallbackErrorCode: 'get_profile_failed');

    final dataJson = _readData(responseData);
    final user = SettingsUserUiModel.fromJson(dataJson);

    if (user.fullName.trim().isEmpty || user.email.trim().isEmpty) {
      await _storageService.clearLoggedInData();
      throw Exception('invalid_user_profile');
    }

    return user;
  }

  Future<void> _cacheUserProfile(SettingsUserUiModel user) async {
    await _storageService.setProfileData(
      fullName: user.fullName,
      email: user.email,
      avatarSeed: user.avatarSeed,
      role: user.role,
    );
  }

  Map<String, dynamic> _readData(Map<String, dynamic>? responseData) {
    if (responseData == null) {
      throw Exception('empty_response');
    }

    final dataJson = responseData['data'];
    if (dataJson is! Map<String, dynamic>) {
      throw Exception('missing_data');
    }

    return dataJson;
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
      final message = _extractMessage(responseData['message']);

      if (message != null) {
        throw Exception(message);
      }

      throw Exception(fallbackErrorCode);
    }
  }

  String? _extractMessage(dynamic rawMessage) {
    if (rawMessage is String && rawMessage.trim().isNotEmpty) {
      return rawMessage.trim();
    }

    if (rawMessage is List && rawMessage.isNotEmpty) {
      final first = rawMessage.first;
      if (first is String && first.trim().isNotEmpty) {
        return first.trim();
      }
    }

    return null;
  }
}
