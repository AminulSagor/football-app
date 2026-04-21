import 'package:flutter/material.dart';
import 'package:fotgram/core/bindings/initial_bindings.dart';
import 'package:fotgram/core/themes/app_theme.dart';
import 'package:fotgram/core/themes/theme_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'routes/routes.dart';
import 'core/bootstrap/bootstrap_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<BootstrapController>(
    () => BootstrapController().init(),
    permanent: true,
  );

  runApp(KicscoreApp(initialRoute: AppPages.initial));
}

class KicscoreApp extends StatelessWidget {
  final String initialRoute;

  const KicscoreApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return ScreenUtilInit(
      designSize: const Size(390, 907),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(
          () => GetMaterialApp(
            initialBinding: InitialBindings(),
            debugShowCheckedModeBanner: false,
            title: 'Kicscore',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,
            initialRoute: initialRoute,
            getPages: AppPages.routes,
          ),
        );
      },
    );
  }
}
