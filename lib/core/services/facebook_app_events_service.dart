import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class FacebookAppEventsService extends GetxService {
  static const String appIdEnvKey = 'FACEBOOK_APP_ID';
  static const String clientTokenEnvKey = 'FACEBOOK_CLIENT_TOKEN';

  final FacebookAppEvents _appEvents = FacebookAppEvents();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  bool get isSupportedPlatform {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }

  Future<FacebookAppEventsService> init() async {
    if (!isSupportedPlatform || _isInitialized) return this;

    if (!_hasRequiredConfiguration) {
      return this;
    }

    try {
      await _appEvents.setAutoLogAppEventsEnabled(true);
      await _appEvents.setAdvertiserIdCollectionEnabled(true);
      _isInitialized = true;
    } catch (error) {
      _isInitialized = false;
    }

    return this;
  }

  bool get _hasRequiredConfiguration {
    return _envValue(appIdEnvKey).isNotEmpty &&
        _envValue(clientTokenEnvKey).isNotEmpty;
  }

  String _envValue(String key) {
    return dotenv.env[key]?.trim() ?? '';
  }
}
