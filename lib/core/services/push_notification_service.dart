import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../firebase_options.dart';
import '../../routes/routes.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class PushNotificationService {
  PushNotificationService._();

  static const String _channelId = 'kicscore_foreground_notifications';
  static const String _channelName = 'Foreground notifications';
  static const String _channelDescription =
      'Notifications shown while Kicscore is open.';

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;

    await _initializeLocalNotifications();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: false,
          badge: false,
          sound: false,
        );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageNavigation);

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _scheduleNavigation();
    }
  }

  static Future<void> _initializeLocalNotifications() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (_) => _scheduleNavigation(),
    );

    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
        ),
      );
      await androidPlugin?.requestNotificationsPermission();
    }
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (_shouldSkipForegroundNotification()) {
      return;
    }

    final notification = message.notification;
    final title = _firstNonEmpty(<String?>[
      notification?.title,
      message.data['title']?.toString(),
      message.data['notification_title']?.toString(),
    ]);
    final body = _firstNonEmpty(<String?>[
      notification?.body,
      message.data['body']?.toString(),
      message.data['message']?.toString(),
      message.data['notification_body']?.toString(),
    ]);

    if (title == null && body == null) {
      return;
    }

    await _localNotifications.show(
      id: _notificationId(message),
      title: title ?? 'Notification',
      body: body ?? '',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: AppRoutes.notifications,
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

  static bool _shouldSkipForegroundNotification() {
    return kIsWeb || (!Platform.isAndroid && !Platform.isIOS);
  }

  static int _notificationId(RemoteMessage message) {
    final id = message.messageId;
    if (id != null && id.trim().isNotEmpty) {
      return id.hashCode & 0x7fffffff;
    }
    return Random().nextInt(0x7fffffff);
  }

  static String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return null;
  }
}
