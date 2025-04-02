import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationsService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  static Future<void> initialize({
    void Function(NotificationResponse)? onDidReceiveNotificationResponse,
  }) async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  // Request notification permissions
  static Future<bool> requestPermissions() async {
    final bool? result = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return result ?? false;
  }

  // Show immediate notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? channelId,
    String? channelName,
    String? channelDescription,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
  }) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channelId ?? 'default_channel_id',
          channelName ?? 'Default Channel',
          channelDescription:
              channelDescription ?? 'Default Notification Channel',
          importance: importance,
          priority: priority,
        );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Add these methods to your LocalNotificationsService class

  /// Schedule watering reminder for a specific plant
  static Future<void> scheduleWateringReminder({
    required int plantId,
    required String plantName,
    required Duration wateringFrequency,
    String? plantImagePath,
    DateTime? firstWateringDate,
  }) async {
    final id =
        plantId; // Using plantId as notification id for easy cancellation

    await scheduleNotification(
      id: id,
      title: 'Time to water your $plantName',
      body: 'Your $plantName needs watering today! 💧',
      scheduledDate: firstWateringDate ?? DateTime.now().add(wateringFrequency),
      payload: 'water_plant_$plantId',
      channelId: 'watering_reminders',
      channelName: 'Watering Reminders',
      channelDescription: 'Reminders to water your plants',
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancel watering reminder for a specific plant
  static Future<void> cancelWateringReminder(int plantId) async {
    await cancelNotification(plantId);
  }

  /// Show immediate watering confirmation
  static Future<void> showWateringConfirmation({
    required int plantId,
    required String plantName,
  }) async {
    await showNotification(
      id: plantId + 1000, // Different ID range for immediate notifications
      title: 'Watering logged',
      body: 'You watered your $plantName 🌱',
      payload: 'watering_logged_$plantId',
      channelId: 'plant_actions',
      channelName: 'Plant Actions',
      channelDescription: 'Plant care confirmations',
    );
  }

  // Schedule a notification
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String? channelId,
    String? channelName,
    String? channelDescription,
    AndroidScheduleMode androidScheduleMode = AndroidScheduleMode.inexact,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channelId ?? 'scheduled_channel_id',
          channelName ?? 'Scheduled Notifications',
          channelDescription:
              channelDescription ?? 'Channel for scheduled notifications',
          importance: Importance.max,
        );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidScheduleMode: androidScheduleMode,
      payload: payload,
      matchDateTimeComponents: matchDateTimeComponents,
    );
  }

  // Cancel notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Get notification launch details
  static Future<NotificationAppLaunchDetails?>
  getNotificationAppLaunchDetails() async {
    return await _notificationsPlugin.getNotificationAppLaunchDetails();
  }
}
