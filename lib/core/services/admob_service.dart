import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  AdMobService._();

  static Future<void> initialize({List<String> testDeviceIds = const []}) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    if (testDeviceIds.isNotEmpty) {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: testDeviceIds),
      );
    }

    await MobileAds.instance.initialize();
  }
}

class AdMobAdUnitIds {
  AdMobAdUnitIds._();

  static const String androidTestAppId =
      'ca-app-pub-3940256099942544~3347511713';

  static const String _androidTestBanner =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _iosTestBanner =
      'ca-app-pub-3940256099942544/2934735716';

  static const String _androidTestNative =
      'ca-app-pub-3940256099942544/2247696110';
  static const String _iosTestNative =
      'ca-app-pub-3940256099942544/3986624511';

  static const String _androidProductionBanner = String.fromEnvironment(
    'ADMOB_ANDROID_BANNER_AD_UNIT_ID',
    defaultValue: _androidTestBanner,
  );
  static const String _iosProductionBanner = String.fromEnvironment(
    'ADMOB_IOS_BANNER_AD_UNIT_ID',
    defaultValue: _iosTestBanner,
  );

  static const String _androidProductionNative = String.fromEnvironment(
    'ADMOB_ANDROID_NATIVE_AD_UNIT_ID',
    defaultValue: _androidTestNative,
  );
  static const String _iosProductionNative = String.fromEnvironment(
    'ADMOB_IOS_NATIVE_AD_UNIT_ID',
    defaultValue: _iosTestNative,
  );

  static String get banner {
    if (Platform.isAndroid) return _androidProductionBanner;
    if (Platform.isIOS) return _iosProductionBanner;
    return _androidTestBanner;
  }

  static String get native {
    if (Platform.isAndroid) return _androidProductionNative;
    if (Platform.isIOS) return _iosProductionNative;
    return _androidTestNative;
  }
}
