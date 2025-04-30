import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:garden_app/models/notification.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize({
    void Function(NotificationResponse)? onDidReceiveNotificationResponse,
  }) async {
    tzdata.initializeTimeZones();
    final String localZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localZone));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
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

  static Future<bool> requestPermissions() async {
    final bool? result = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return result ?? false;
  }

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
  }) => _notificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    // correct timezone
    tz.TZDateTime(
      tz.local,
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      scheduledDate.hour,
      scheduledDate.minute,
    ),
    NotificationDetails(
      android: AndroidNotificationDetails(
        channelId ?? 'scheduled_channel_id',
        channelName ?? 'Scheduled Notifications',
        channelDescription:
            channelDescription ?? 'Channel for scheduled notifications',
        importance: Importance.max,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ),
    androidScheduleMode: androidScheduleMode,
    payload: payload,
    matchDateTimeComponents: matchDateTimeComponents,
  );

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  static Future<NotificationAppLaunchDetails?>
  getNotificationAppLaunchDetails() async {
    return await _notificationsPlugin.getNotificationAppLaunchDetails();
  }

  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  static Future<void> rescheduleAll(
    List<PlantNotification> notifications,
  ) async {
    await cancelAllNotifications();

    final tzNow = tz.TZDateTime.now(tz.local);
    for (final n in notifications) {
      final tzDate = tz.TZDateTime(
        tz.local,
        n.nextOccurrence.year,
        n.nextOccurrence.month,
        n.nextOccurrence.day,
        n.nextOccurrence.hour,
        n.nextOccurrence.minute,
      );

      if (!tzDate.isAfter(tzNow)) continue; // skip non future

      await scheduleNotification(
        id: n.id,
        title: 'Water plant',
        body: n.message,
        scheduledDate: DateTime(
          tzDate.year,
          tzDate.month,
          tzDate.day,
          tzDate.hour,
          tzDate.minute,
        ),
        payload: 'water_plant_${n.plantId}_${n.id}',
        matchDateTimeComponents:
            n.repeatEveryDays != null ? DateTimeComponents.time : null,
      );
    }
  }
}
