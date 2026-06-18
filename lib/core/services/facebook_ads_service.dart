import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class FacebookAdsService extends GetxService {
  static const String appIdEnvKey = 'FACEBOOK_APP_ID';
  static const String bannerAdIdEnvKey = 'FACEBOOK_BANNER_AD_ID';
  static const String nativeAdIdEnvKey = 'FACEBOOK_NATIVE_AD_ID';
  static const String testingIdEnvKey = 'FACEBOOK_TESTING_ID';
  static const String testAdsEnabledEnvKey = 'FACEBOOK_TEST_ADS_ENABLED';
  static const String adsModeEnvKey = 'FACEBOOK_ADS_MODE';
  static const String productionAdsEnabledEnvKey =
      'FACEBOOK_PRODUCTION_ADS_ENABLED';
  static const String bannerTestAdTypeEnvKey = 'FACEBOOK_BANNER_TEST_AD_TYPE';
  static const String nativeTestAdTypeEnvKey = 'FACEBOOK_NATIVE_TEST_AD_TYPE';

  static const String _defaultTestAdType = 'IMG_16_9_APP_INSTALL';

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  bool get isSupportedPlatform {
    if (kIsWeb) return false;

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  bool get isTestMode {
    final mode = _envValue(adsModeEnvKey).toLowerCase();

    if (mode == 'test' || mode == 'testing') return true;
    if (mode == 'prod' || mode == 'production' || mode == 'release') {
      return false;
    }

    if (kReleaseMode) return false;
    if (_envBool(productionAdsEnabledEnvKey)) return false;
    if (_envBool(testAdsEnabledEnvKey)) return true;

    return kDebugMode || kProfileMode;
  }

  String get appId => _envValue(appIdEnvKey);

  String get bannerAdId => _envValue(bannerAdIdEnvKey);

  String get nativeAdId => _envValue(nativeAdIdEnvKey);

  String get testingId => _envValue(testingIdEnvKey);

  String get bannerPlacementId {
    return _placementId(
      placementId: bannerAdId,
      testAdType: _envValue(bannerTestAdTypeEnvKey),
    );
  }

  String get nativePlacementId {
    return _placementId(
      placementId: nativeAdId,
      testAdType: _envValue(nativeTestAdTypeEnvKey),
    );
  }

  bool get canShowBannerAd {
    return isSupportedPlatform && isInitialized && bannerPlacementId.isNotEmpty;
  }

  bool get canShowNativeAd {
    return isSupportedPlatform && isInitialized && nativePlacementId.isNotEmpty;
  }

  Future<FacebookAdsService> init() async {
    if (!isSupportedPlatform || _isInitialized) return this;

    try {
      FacebookAudienceNetwork.init(
        testingId: isTestMode ? testingId : '',
        iOSAdvertiserTrackingEnabled: true,
      );
      _isInitialized = true;

      if (kDebugMode) {
        debugPrint(
          'Facebook ads initialized. Test mode: ${isTestMode ? 'enabled' : 'disabled'}',
        );
      }
    } catch (error, stackTrace) {
      _isInitialized = false;
      if (kDebugMode) {
        debugPrint('Facebook ads initialization failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    return this;
  }

  String _placementId({
    required String placementId,
    required String testAdType,
  }) {
    if (placementId.isEmpty) return '';
    if (!isTestMode || placementId.contains('#')) return placementId;

    final resolvedTestAdType = testAdType.isEmpty ? _defaultTestAdType : testAdType;
    return '$resolvedTestAdType#$placementId';
  }

  bool _envBool(String key) {
    final value = _envValue(key).toLowerCase();
    return value == 'true' || value == '1' || value == 'yes';
  }

  String _envValue(String key) {
    return dotenv.env[key]?.trim() ?? '';
  }
}
