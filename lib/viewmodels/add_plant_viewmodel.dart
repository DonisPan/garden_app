import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/repositories/plant_remote_repository.dart';

class AddPlantViewModel extends ChangeNotifier {
  final PlantRemoteRepository plantRepository;

  AddPlantViewModel({required this.plantRepository}) {
    fetchAllData();
  }

  List<Plant> _plants = [];
  List<Plant> get plants => _plants;

  List<PlantClass> _classes = [];
  List<PlantClass> get classes => _classes;

  List<PlantFamily> _families = [];
  List<PlantFamily> get families => _families;

  Plant? selectedPlant;
  PlantClass? selectedPlantClass;
  PlantFamily? selectedPlantFamily;

  final TextEditingController customNameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  bool isCustom = false;
  bool needWater = false;

  String? errorMessage;
  bool isLoading = false;

  Future<void> fetchAllData() async {
    _plants = await plantRepository.getAllPlants();
    _classes = await plantRepository.getAllClasses();
    _families = await plantRepository.getAllFamilies();
    notifyListeners();
  }

  Future<void> addPlant() async {
    if (!isCustom && selectedPlant != null) {
      print('Calling in viewmodel');
      await plantRepository.addPlant(
        selectedPlant!.id,
        customNameController.text,
      );
    }
    notifyListeners();
  }

  @override
  void dispose() {
    customNameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void leftButton(BuildContext context) {
    Navigator.pop(context);
  }
}
