import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      // Обработчик нажатия на уведомление
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('notification_pending', true);
      },
    );
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'romalingo_channel', // Уникальный ID
          'Romalingo Notifications', // Видимое имя
          channelDescription: 'Канал для уведомлений Romalingo',
          importance: Importance.high,
          priority: Priority.high,
          enableLights: true,
          enableVibration: true,
          playSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'study_time',
    );
  }
}
