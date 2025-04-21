import 'package:garden_app/models/notification.dart';

class Plant {
  final int _id;
  final String _name;
  final String? _note;
  final PlantClass? _plantClass;
  final PlantFamily? _plantFamily;
  final bool _isCustom;
  List<PlantNotification> notifications;

  Plant({
    required int id,
    required String name,
    String? note,
    required PlantClass? plantClass,
    required PlantFamily? plantFamily,
    required bool isCustom,
    List<PlantNotification>? notifications,
  }) : _id = id,
       _name = name,
       _note = note,
       _plantClass = plantClass,
       _plantFamily = plantFamily,
       _isCustom = isCustom,
       notifications = notifications ?? [];

  int get id => _id;
  String get name => _name;
  String? get note => _note;
  PlantClass? get plantClass => _plantClass;
  PlantFamily? get plantFamily => _plantFamily;
  bool get isCustom => _isCustom;

  void addNotification(PlantNotification notification) {
    notifications.add(notification);
  }

  void removeNotification(PlantNotification notification) {
    notifications.remove(notification);
  }

  void clearNotifications() {
    notifications.clear();
  }
}

class PlantFamily {
  final int _id;
  final String _nameCommon;
  final String _nameScientific;

  PlantFamily({
    required int id,
    required String nameCommon,
    required String nameScientific,
  }) : _id = id,
       _nameCommon = nameCommon,
       _nameScientific = nameScientific;

  int get id => _id;
  String? get nameCommon => _nameCommon;
  String? get nameScientific => _nameScientific;
}

class PlantClass {
  final int _id;
  final String _name;

  PlantClass({required int id, required String name}) : _id = id, _name = name;

  int get id => _id;
  String? get name => _name;
}
