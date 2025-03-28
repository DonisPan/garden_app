import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/repositories/plant_repository.dart';

class PlantDetailViewModel extends ChangeNotifier {
  final Plant plant;
  final PlantRepository plantRepository;

  PlantDetailViewModel({required this.plant, required this.plantRepository});

  Future<void> deletePlant(BuildContext context) async {
    await plantRepository.removePlant(plant.id);
    notifyListeners();
    Navigator.pop(context);
  }

  Future<void> manageNotifications(BuildContext context) async {}
}
