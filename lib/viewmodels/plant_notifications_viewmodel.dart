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

  DateTime _pickDate;
  TimeOfDay _pickTime;
  bool _repeat;
  int _days;
  final TextEditingController messageController;

  PlantNotificationsViewModel({
    required this.plant,
    required this.plantRepository,
  }) : _pickDate = DateTime.now(),
       _pickTime = TimeOfDay.now(),
       _repeat = false,
       _days = 1,
       messageController = TextEditingController();

  DateTime get pickDate => _pickDate;
  set pickDate(DateTime val) {
    _pickDate = val;
    notifyListeners();
  }

  TimeOfDay get pickTime => _pickTime;
  set pickTime(TimeOfDay val) {
    _pickTime = val;
    notifyListeners();
  }

  bool get repeat => _repeat;
  set repeat(bool val) {
    _repeat = val;
    notifyListeners();
  }

  int get days => _days;
  set days(int val) {
    _days = val;
    notifyListeners();
  }

  List<PlantNotification> get notifications => plant.notifications;

  Future<void> scheduleNotification(PlantNotification notification) async {
    await LocalNotificationsService.scheduleNotification(
      id: notification.id,
      title: plant.name,
      body: notification.message,
      scheduledDate: notification.nextOccurrence,
      payload: '${plant.id}_${notification.id}',
      matchDateTimeComponents:
          notification.repeatEveryDays != null ? DateTimeComponents.time : null,
    );
  }

  Future<void> addNotification({
    required String message,
    required DateTime startDate,
    required int? repeatEveryDays,
  }) async {
    final newNotification = await plantRepository.addPlantNotification(
      plant.id,
      message,
      startDate,
      repeatEveryDays,
    );
    plant.addNotification(newNotification!);
    await scheduleNotification(newNotification);
    notifyListeners();
  }

  Future<void> deleteNotification(PlantNotification notification) async {
    await LocalNotificationsService.cancelNotification(notification.id);
    plantRepository.removeNotification(notification);
    plant.removeNotification(notification);
    notifyListeners();
  }

  void leftButton(BuildContext context) => Navigator.of(context).pop();

  void rightButton(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddPlantNotificationPage(plant: plant)),
    );
  }
}
