import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';

import '../models/device_tokens_payload.dart';
import '../models/device_tokens_response.dart';
import 'api_error_handler.dart';
import 'api_client.dart';
import 'storage_service.dart';

class FcmTokenService {
  FcmTokenService._();
  //final ApiClient _apiClient;

  static const String _lastSentTokenKey = 'last_sent_fcm_token';

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    //_apiClient = Get.find<ApiClient>();
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    final String? token = await _messaging.getToken();
    final prefs = await SharedPreferences.getInstance();

    if (token != null && _shouldSendToken(prefs, token)) {
      await _sendTokenToBackend(token);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) async {
      final prefs = await SharedPreferences.getInstance();
      if (_shouldSendToken(prefs, newToken)) {
        await _sendTokenToBackend(newToken);
      }
    });
  }

  static Future<ApiResponseModel<DeviceTokenResponseModel>> _sendTokenToBackend(
    String token,
  ) async {
    // TODO: call your backend API here
    final String platform = Platform.isAndroid ? 'android' : 'ios';
    final String installationId = await _resolveInstallationId();
    print('Installation ID: $installationId');
    final String appVersion = await _getAppVersion();
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final String deviceModel = await _getDeviceModel(deviceInfoPlugin);
    final String osVersion = await _getOsVersion(deviceInfoPlugin);
    final String locale = PlatformDispatcher.instance.locale.toLanguageTag();
    final String timeZone = FlutterTimezone.getLocalTimezone().toString();

    final payload = DeviceTokensPayload(
      fcmToken: token,
      platform: platform,
      installationId: installationId,
      appVersion: appVersion,
      deviceModel: deviceModel,
      osVersion: osVersion,
      locale: locale,
      timezone: timeZone,
    );

    final result = await ApiErrorHandler.handle<DeviceTokenResponseModel>(
      () async {
        final apiClient = Get.find<ApiClient>();
        final response = await apiClient.post<Map<String, dynamic>>(
          '/device-tokens/register',
          data: DeviceTokensPayload.toJson(payload),
        );
        final responseData = response.data;
        if (responseData == null) {
          throw Exception('empty_response');
        }
        return DeviceTokenResponseModel.fromJson(responseData);
      },
    );
    if (result.success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastSentTokenKey, token);
    }
    return result;
    //final deviceModel = print('FCM Token: ${payload.fcmToken}');
  }

  static bool _shouldSendToken(SharedPreferences prefs, String token) {
    final lastSentToken = prefs.getString(_lastSentTokenKey);
    return lastSentToken != token;
  }

  static Future<String> _resolveInstallationId() async {
    final storageService = Get.find<StorageService>();
    final cachedInstallationId = storageService.installationId.trim();
    if (cachedInstallationId.isNotEmpty) {
      return cachedInstallationId;
    }

    final resolvedInstallationId = await FirebaseInstallations.instance.getId();
    await storageService.setInstallationId(resolvedInstallationId);
    return resolvedInstallationId;
  }

  static Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }

  static Future<String> _getDeviceModel(
    DeviceInfoPlugin deviceInfoPlugin,
  ) async {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.utsname.machine;
    } else {
      return 'unknown device';
    }
  }

  static Future<String> _getOsVersion(DeviceInfoPlugin deviceInfoPlugin) async {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return 'Android ${androidInfo.version.release}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return 'iOS ${iosInfo.systemVersion}';
    } else {
      return 'unknown OS';
    }
  }
}
