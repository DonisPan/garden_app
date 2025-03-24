import 'package:garden_app/models/plant.dart';
import 'package:garden_app/models/statistics.dart';

abstract class PlantRepository {
  Future<List<Plant>> getPlants(int userId);
  Future<String?> renamePlant(int id, String newName);
  Future<String?> changeClass(int id, String newClass);
  Future<String?> changeFamily(int id, String newFamily);
  Future<String?> removePlant(int id);
  Future<Statistics?> getStatistics(int userId);
  Future<String?> addPlant(Plant plant);
}
