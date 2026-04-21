import 'package:get/get.dart';
import '../../routes/routes.dart';
import '../services/services.dart';
import '../themes/theme_controller.dart';

class BootstrapController extends GetxService {
  //@override
  Future<BootstrapController> init() async {
    await Get.putAsync<StorageService>(
      () => StorageService().init(),
      permanent: true,
    );
    final themeController = await Get.putAsync<ThemeController>(
      () async => ThemeController(themeService: ThemeService()),
      permanent: true,
    );
    await themeController.loadSavedTheme();
    return this;
  }

  @override
  void onReady() {
    super.onReady();
    // Simulate some initialization work
    Future.delayed(const Duration(seconds: 1), () {
      // After initialization, navigate to the login screen
      Get.offAllNamed(AppRoutes.bottomNav);
    });
  }
}
