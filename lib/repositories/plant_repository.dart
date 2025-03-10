import 'package:garden_app/models/plant.dart';

abstract class PlantRepository {
  Future<List<Plant>> getPlants();
  Future<String?> renamePlant(int id, String newName);
  Future<String?> changeClass(int id, String newClass);
  Future<String?> changeFamily(int id, String newFamily);
  Future<String?> removePlant(int id);
}
