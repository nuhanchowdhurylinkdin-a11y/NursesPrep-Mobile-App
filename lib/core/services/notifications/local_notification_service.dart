// import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'default_channel';
  static const _channelName = 'General Notifications';
  static const _channelDesc = 'Default channel for app notifications';

  static void Function(String payload)? onTap;

  static Future<void> init({void Function(String payload)? onTapHandler}) async {
    onTap = onTapHandler;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          onTap?.call(payload);
        }
      },
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDesc,
          importance: Importance.high,
        ));
  }

  static Future<void> show({
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
  }) async {
    BigPictureStyleInformation? bigPictureStyle;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final path = await _downloadImage(imageUrl);
        bigPictureStyle = BigPictureStyleInformation(
          FilePathAndroidBitmap(path),
          contentTitle: title,
          summaryText: body,
        );
      } catch (e) {
        // log('LocalNotification image download failed: $e');
      }
    }

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigPictureStyle,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails:
          NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload,
    );
  }

  static Future<void> clearBadge() async {
    await _plugin.cancelAll();
    if (Platform.isIOS) {
      await _plugin.show(
        id: 0,
        title: '',
        body: '',
        notificationDetails: const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: false,
            presentBadge: true,
            presentSound: false,
            badgeNumber: 0,
          ),
        ),
      );
    }
  }

  static Future<String> _downloadImage(String url) async {
    final dir = await getTemporaryDirectory();
    final filePath =
        '${dir.path}/ntf_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
