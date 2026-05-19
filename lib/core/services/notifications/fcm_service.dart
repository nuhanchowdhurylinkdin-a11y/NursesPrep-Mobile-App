import 'dart:convert';
// import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../firebase_options.dart';
import 'local_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  // log('━━━ FCM BACKGROUND ━━━');
  // log('msgId: ${message.messageId}');
  // log('notification: ${message.notification?.title} | ${message.notification?.body}');
  // log('data: ${message.data}');
  // log('━━━━━━━━━━━━━━━━━━━━━━');
}

class FcmService {
  FcmService._();

  static final _messaging = FirebaseMessaging.instance;

  static void Function(String token)? onTokenChanged;
  static void Function(String? screen, Map<String, dynamic> data)? onMessageTap;

  static Future<void> init({
    void Function(String token)? onTokenChangedHandler,
    void Function(String? screen, Map<String, dynamic> data)? onMessageTapHandler,
  }) async {
    onTokenChanged = onTokenChangedHandler;
    onMessageTap = onMessageTapHandler;

    // ignore: unused_local_variable
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    // log('FCM permission status: ${settings.authorizationStatus}');

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);

    _messaging.onTokenRefresh.listen((token) {
      // log('━━━━━━━━━━ FCM TOKEN REFRESHED ━━━━━━━━━━');
      // log(token);
      // log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      onTokenChanged?.call(token);
    });

    final initialToken = await getToken();
    if (initialToken != null) onTokenChanged?.call(initialToken);
  }

  /// Call this AFTER the app has navigated to home, to handle a notification
  /// that launched the app from a killed state.
  static Future<void> handleInitialMessage() async {
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      // log('FCM initial message: ${initial.data}');
      _onMessageOpened(initial);
    }
  }

  static Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      // log('━━━━━━━━━━ FCM TOKEN ━━━━━━━━━━');
      // log('$token');
      // log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      return token;
    } catch (e) {
      // log('FCM getToken failed: $e');
      return null;
    }
  }

  static void _onForegroundMessage(RemoteMessage message) {
    // log('━━━ FCM FOREGROUND ━━━');
    // log('notification: ${message.notification?.title} | ${message.notification?.body}');
    // log('data: ${message.data}');
    // log('━━━━━━━━━━━━━━━━━━━━━━');

    final notification = message.notification;
    if (notification == null) return;

    final imageUrl = notification.android?.imageUrl ?? notification.apple?.imageUrl;

    LocalNotificationService.show(
      title: notification.title ?? '',
      body: notification.body ?? '',
      payload: jsonEncode(message.data),
      imageUrl: imageUrl,
    );
  }

  static void _onMessageOpened(RemoteMessage message) {
    // log('━━━ FCM TAPPED (background→foreground) ━━━');
    // log('data: ${message.data}');
    // log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    onMessageTap?.call(
      message.data['screen']?.toString(),
      message.data,
    );
  }
}
