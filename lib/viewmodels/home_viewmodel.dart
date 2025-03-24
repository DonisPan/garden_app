import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/repositories/auth_repository.dart';
import 'package:garden_app/repositories/plant_repository.dart';
import 'package:garden_app/services/global.dart';

class HomeViewModel extends ChangeNotifier {
  final PlantRepository plantRepository;
  final AuthRepository authRepository;

  TextEditingController searchQueryController = TextEditingController();

  List<Plant> _plants = [];
  List<Plant> get plants => _plants;

  HomeViewModel({required this.plantRepository, required this.authRepository}) {
    fetchPlants();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void updateSearchQuery(String query) {
    _searchQuery = query;

    notifyListeners();
  }

  void leftButton(BuildContext context) {
    Global().authorized
        ? Navigator.pushNamed(context, '/profile')
        : Navigator.pushNamed(context, '/login');
  }

  void rightButton(BuildContext context) {
    Navigator.pushNamed(context, '/addPlant');
  }

  Future<void> fetchPlants() async {
    final userId = await Global().getUserId();
    if (userId == null) {
      _plants = [];
      return;
    }
    _plants = await plantRepository.getPlants(userId);
    notifyListeners();
  }

  void water(Plant plant) {
    plant.needWater = !plant.needWater;
    notifyListeners();
  }

  @override
  void dispose() {
    searchQueryController.dispose();
    super.dispose();
  }
}
