import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../../routes/routes.dart';
import '../services/facebook_app_events_service.dart';
import '../services/fcm_token_service.dart';
import '../services/push_notification_service.dart';
import '../services/services.dart';
import '../themes/theme_controller.dart';

class BootstrapController extends GetxService {
  Future<BootstrapController> init() async {
    await dotenv.load(fileName: '.env');
    final storageService = await Get.putAsync<StorageService>(
      () => StorageService().init(),
      permanent: true,
    );
    final apiClient = Get.put<ApiClient>(
      ApiClient(client: null, storageService: storageService),
      permanent: true,
    );
    unawaited(apiClient.preloadInstallationId());
    await Get.putAsync<FacebookAppEventsService>(
      () => FacebookAppEventsService().init(),
      permanent: true,
    );
    await Get.putAsync<FacebookAdsService>(
      () => FacebookAdsService().init(),
      permanent: true,
    );
    final themeController = await Get.putAsync<ThemeController>(
      () async => ThemeController(themeService: ThemeService()),
      permanent: true,
    );
    await themeController.loadSavedTheme();

    final connectivityService = Get.put<ConnectivityService>(
      ConnectivityService(),
      permanent: true,
    );

    unawaited(_initDeferredServices(connectivityService));
    return this;
  }

  Future<void> _initDeferredServices(
    ConnectivityService connectivityService,
  ) async {
    try {
      await Future.wait<void>([
        connectivityService.init().then((_) {}),
        FcmTokenService.init(),
        PushNotificationService.init(),
      ], eagerError: false);
    } catch (_) {
      // Deferred startup services should not block the first app screen.
    }
  }

  @override
  void onReady() {
    super.onReady();
    Future.microtask(() {
      if (Get.currentRoute == AppRoutes.bootstrap) {
        Get.offAllNamed(AppRoutes.bottomNav);
      }
    });
  }
}
