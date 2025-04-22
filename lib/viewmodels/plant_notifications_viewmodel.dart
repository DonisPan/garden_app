import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:garden_app/models/notification.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/repositories/plant_repository.dart';
import 'package:garden_app/services/local_notification_service.dart';
import 'package:garden_app/views/add_plant_notification.dart';

class PlantNotificationsViewModel extends ChangeNotifier {
  final Plant plant;
  final PlantRepository plantRepository;

  PlantNotificationsViewModel({
    required this.plant,
    required this.plantRepository,
  });

  List<PlantNotification> get notifications => plant.notifications;

  Future<void> _scheduleSystemNotification(
    PlantNotification notification,
  ) async {
    await LocalNotificationsService.scheduleNotification(
      id: notification.id,
      title: 'Water ${plant.name}',
      body: notification.message,
      scheduledDate: notification.nextOccurrence,
      payload: 'water_plant_${plant.id}_${notification.id}',
      matchDateTimeComponents:
          notification.repeatEveryDays != null ? DateTimeComponents.time : null,
    );
  }

  Future<void> addNotification({
    required String message,
    required DateTime startDate,
    required int? repeatEveryDays,
  }) async {
    final notification = PlantNotification(
      id: _generateNotificationId(),
      plantId: plant.id,
      message: message,
      startDate: startDate,
      repeatEveryDays: repeatEveryDays,
    );
    plant.addNotification(notification);
    plantRepository.addNotification(notification);
    await _scheduleSystemNotification(notification);
    notifyListeners();
  }

  Future<void> updateNotification({
    required PlantNotification notification,
    required String message,
    required DateTime startDate,
    required int? repeatEveryDays,
  }) async {
    await LocalNotificationsService.cancelNotification(notification.id);
    final updated = notification.copyWith(
      message: message,
      startDate: startDate,
      repeatEveryDays: repeatEveryDays,
    );
    final idx = plant.notifications.indexOf(notification);
    plant.notifications[idx] = updated;
    if (updated.isActive) {
      await _scheduleSystemNotification(updated);
    }
    notifyListeners();
  }

  Future<void> toggleNotification(PlantNotification notification) async {
    final updated = notification.copyWith(isActive: !notification.isActive);
    final idx = plant.notifications.indexOf(notification);
    plant.notifications[idx] = updated;
    if (notification.isActive) {
      await LocalNotificationsService.cancelNotification(notification.id);
    } else {
      await _scheduleSystemNotification(updated);
    }
    notifyListeners();
  }

  Future<void> deleteNotification(PlantNotification notification) async {
    await LocalNotificationsService.cancelNotification(notification.id);
    plant.removeNotification(notification);
    // plantRepository.removeNotification(notification);
    notifyListeners();
  }

  int _generateNotificationId() {
    final int low = DateTime.now().millisecondsSinceEpoch % 1000000;
    return plant.id * 1000000 + low;
  }

  void editNotification(BuildContext context, PlantNotification notification) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddPlantNotificationPage(plant: plant)),
    );
  }

  void leftButton(BuildContext context) {
    Navigator.of(context).pop();
  }

  void rightButton(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddPlantNotificationPage(plant: plant)),
    );
  }
}
