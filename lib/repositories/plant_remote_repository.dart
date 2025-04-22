import 'package:garden_app/models/notification.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/models/statistics.dart';
import 'package:garden_app/repositories/plant_repository.dart';
import 'package:garden_app/services/supabase_service.dart';

class PlantRemoteRepository implements PlantRepository {
  @override
  Future<String?> changeClass(int id, String newClass) {
    // TODO: implement changeClass
    throw UnimplementedError();
  }

  @override
  Future<String?> changeFamily(int id, String newFamily) {
    // TODO: implement changeFamily
    throw UnimplementedError();
  }

  @override
  Future<List<Plant>> getPlants(int userId) {
    return SupabaseService().getPlants(userId: userId);
  }

  @override
  Future<List<Plant>> getAllPlants() {
    return SupabaseService().getAllPlants();
  }

  @override
  Future<String?> removePlant(int id) {
    return SupabaseService().removePlant(id);
  }

  @override
  Future<String?> renamePlant(int id, String newName) {
    // TODO: implement renamePlant
    throw UnimplementedError();
  }

  @override
  Future<Statistics?> getStatistics(int userId) {
    return SupabaseService().getStatistics(userId);
  }

  @override
  Future<List<PlantClass>> getAllClasses() {
    return SupabaseService().getClasses();
  }

  @override
  Future<List<PlantFamily>> getAllFamilies() {
    return SupabaseService().getFamilies();
  }

  @override
  Future<String?> addCustomPlant(
    String name,
    String? note,
    int? plantClass,
    int? plantFamily,
  ) async {
    return await SupabaseService().addCustomPlant(
      name,
      note,
      plantClass,
      plantFamily,
    );
  }

  @override
  Future<String?> addPlant(int id, String? customName) async {
    return await SupabaseService().addPlant(customName, id: id);
  }

  @override
  Future<String?> addNotification(PlantNotification notification) async {
    return await SupabaseService().addNotification(notification);
  }
}
