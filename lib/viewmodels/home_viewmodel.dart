import 'package:flutter/material.dart';
import 'package:garden_app/models/admin_announcer.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/repositories/auth_repository.dart';
import 'package:garden_app/repositories/plant_repository.dart';
import 'package:garden_app/services/global.dart';
import 'package:garden_app/viewmodels/special_announcers_viewmodel.dart';
import 'package:garden_app/views/special_announcers.dart';
import 'package:provider/provider.dart';

class HomeViewModel extends ChangeNotifier {
  final PlantRepository plantRepository;
  final AuthRepository authRepository;

  TextEditingController searchQueryController = TextEditingController();

  List<Plant> _plants = [];
  List<Plant> get plants => _plants;
  List<Plant> _filteredPlants = [];
  List<Plant> get filteredPlants => _filteredPlants;

  List<AdminAnnouncer> specialAnnouncers = [];

  HomeViewModel({required this.plantRepository, required this.authRepository}) {
    fetchPlants();
  }

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

  Future<void> fetchAnnouncers() async {
    specialAnnouncers = await plantRepository.getSpecialAnnouncers(plants);
    notifyListeners();
  }

  void openSpecialAnnouncers(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (ctx) => ChangeNotifierProvider(
              create:
                  (_) => SpecialAnnouncersViewModel(
                    plantRepository: context.read<PlantRepository>(),
                    announcers: specialAnnouncers,
                  ),
              child: SpecialAnnouncersPage(announcers: specialAnnouncers),
            ),
      ),
    );
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
    fetchAnnouncers();
  }

  void leftButton(BuildContext context) {
    Global().authorized
        ? Navigator.pushNamed(context, '/profile')
        : Navigator.pushNamed(context, '/login');
  }

  void rightButton(BuildContext context) {
    Navigator.pushNamed(context, '/addPlant');
  }

  @override
  void dispose() {
    searchQueryController.dispose();
    super.dispose();
  }
}
