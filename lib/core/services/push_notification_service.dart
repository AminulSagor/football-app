import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../firebase_options.dart';
import '../../routes/routes.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class PushNotificationService {
  PushNotificationService._();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageNavigation);

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _scheduleNavigation();
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    if (_shouldSkipInAppAlert()) {
      return;
    }

    final notification = message.notification;
    final title = notification?.title?.trim();
    final body = notification?.body?.trim();

    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    Get.snackbar(
      title ?? 'Notification',
      body ?? '',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
    );
  }

  static void _handleMessageNavigation(RemoteMessage _) {
    _scheduleNavigation();
  }

  static void _scheduleNavigation() {
    if (Get.key.currentState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.key.currentState != null) {
          Get.toNamed(AppRoutes.notifications);
        }
      });
      return;
    }

    Get.toNamed(AppRoutes.notifications);
  }

  static bool _shouldSkipInAppAlert() {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }
}
