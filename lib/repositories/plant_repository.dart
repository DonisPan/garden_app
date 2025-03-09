import 'package:garden_app/models/plant.dart';

abstract class PlantRepository {
  Future<Plant> getPlant();
}