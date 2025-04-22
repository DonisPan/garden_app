import 'package:garden_app/models/notification.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/models/statistics.dart';

abstract class PlantRepository {
  Future<List<Plant>> getAllPlants();
  Future<List<PlantClass>> getAllClasses();
  Future<List<PlantFamily>> getAllFamilies();

  Future<List<Plant>> getPlants(int userId);
  Future<String?> renamePlant(int id, String newName);
  Future<String?> addPlant(int id, String? customName);
  Future<String?> addCustomPlant(
    String name,
    String? note,
    int? plantClass,
    int? plantFamily,
  );
  Future<String?> removePlant(int id);

  // Future<String?> addNotification(PlantNotification notification);
  Future<PlantNotification?> addPlantNotification(
    int plantId,
    String message,
    DateTime startDate,
    int? repeatEveryDays,
  );
  Future<String?> removeNotification(PlantNotification notification);

  Future<String?> changeClass(int id, String newClass);
  Future<String?> changeFamily(int id, String newFamily);

  Future<Statistics?> getStatistics(int userId);
}
