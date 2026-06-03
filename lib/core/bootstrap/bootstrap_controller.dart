import 'package:get/get.dart';
import '../../routes/routes.dart';
import '../services/services.dart';
import '../themes/theme_controller.dart';
import '../services/fcm_token_service.dart';
import '../services/push_notification_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BootstrapController extends GetxService {
  Future<BootstrapController> init() async {
    await dotenv.load(fileName: '.env');
    final storageService = await Get.putAsync<StorageService>(
      () => StorageService().init(),
      permanent: true,
    );
    Get.put<ApiClient>(
      ApiClient(client: null, storageService: storageService),
      permanent: true,
    );
    final themeController = await Get.putAsync<ThemeController>(
      () async => ThemeController(themeService: ThemeService()),
      permanent: true,
    );
    await themeController.loadSavedTheme();

    await Get.putAsync<ConnectivityService>(
      () => ConnectivityService().init(),
      permanent: true,
    );

    await FcmTokenService.init();
    await PushNotificationService.init();
    return this;
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 1), () {
      if (Get.currentRoute == AppRoutes.bootstrap || Get.currentRoute.isEmpty) {
        Get.offAllNamed(AppRoutes.bottomNav);
      }
    });
  }
}
