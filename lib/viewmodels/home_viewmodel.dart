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
  List<Plant> _filteredPlants = [];
  List<Plant> get filteredPlants => _filteredPlants;

  HomeViewModel({required this.plantRepository, required this.authRepository}) {
    fetchPlants();
  }

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void updateSearchQuery(String query) {
    if (query.isEmpty) {
      _filteredPlants = List.from(_plants);
    } else {
      _filteredPlants =
          _plants
              .where(
                (plant) =>
                    plant.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
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
    _filteredPlants = _plants;
    notifyListeners();
  }

  @override
  void dispose() {
    searchQueryController.dispose();
    super.dispose();
  }
}
