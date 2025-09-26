import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SettingsManager {
  static const String _optionKey = 'selected_option';
  static const String _numberKey = 'selected_number';
  static const String _notificationPendingKey = 'notification_pending';
  static const String _timerActiveKey = 'timer_active';
  static const String _lastNotificationTimeKey = 'last_notification_time';
  static const String _scheduledNotificationTime = 'scheduled_notification_time';

  // Базовые настройки
  static const int defaultOption = 0;
  static const double defaultNumber = 30;
  static const double minNumber = 10;
  static const double maxNumber = 60 * 2;

  static Future<void> saveOption(int option) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_optionKey, option);
  }

  static Future<void> saveNumber(double number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_numberKey, number);
  }

  static Future<int> loadOption() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_optionKey) ?? defaultOption;
  }

  static Future<double> loadNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_numberKey) ?? defaultNumber;
  }

  static Future<bool> isNotificationPending() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationPendingKey) ?? false;
  }

  static Future<void> setNotificationPending(bool pending) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationPendingKey, pending);
  }

  static Future<bool> isTimerActive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_timerActiveKey) ?? false;
  }

  static Future<void> setTimerActive(bool active) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_timerActiveKey, active);
  }

  static Future<void> setLastNotificationTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastNotificationTimeKey, time.toIso8601String());
  }

  static Future<void> setScheduledNotificationTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scheduledNotificationTime, time.toIso8601String());
  }

  static Future<DateTime?> getScheduledNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeString = prefs.getString(_scheduledNotificationTime);
    return timeString != null ? DateTime.parse(timeString) : null;
  }

  static Future<void> clearScheduledNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_scheduledNotificationTime);
  }

  static Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_optionKey);
    await prefs.remove(_numberKey);
    await prefs.remove(_notificationPendingKey);
    await prefs.remove(_timerActiveKey);
    await prefs.remove(_lastNotificationTimeKey);
  }
}
