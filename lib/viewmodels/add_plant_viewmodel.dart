import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/repositories/plant_remote_repository.dart';

class AddPlantViewModel extends ChangeNotifier {
  final PlantRemoteRepository plantRepository;

  // Text controllers for each field.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController plantClassController = TextEditingController();
  final TextEditingController familyCommonController = TextEditingController();
  final TextEditingController familyScientificController =
      TextEditingController();

  // Additional properties.
  bool isCustom = false;
  bool needWater = false;

  // For error and loading states.
  String? errorMessage;
  bool isLoading = false;

  AddPlantViewModel({required this.plantRepository});

  /// Stub method: Validate inputs.
  String? _validate() {
    String name = nameController.text.trim();
    String plantClass = plantClassController.text.trim();
    String familyCommon = familyCommonController.text.trim();
    String familyScientific = familyScientificController.text.trim();

    if (name.isEmpty ||
        plantClass.isEmpty ||
        familyCommon.isEmpty ||
        familyScientific.isEmpty) {
      return "Please fill in all required fields.";
    }
    return null;
  }

  /// Stub method: Add a plant.
  Future<void> addPlant() async {
    errorMessage = _validate();
    if (errorMessage != null) {
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      // Create a new Plant instance.
      // In a real app, you would probably send these values to your repository
      // and then get back an assigned id. For now, we use a dummy id (e.g., 0).
      final newPlant = Plant(
        id: 0, // Dummy id; the repository should assign the real id.
        name: nameController.text.trim(),
        note:
            noteController.text.trim().isEmpty
                ? null
                : noteController.text.trim(),
        plantClass: plantClassController.text.trim(),
        familyCommon: familyCommonController.text.trim(),
        familyScientific: familyScientificController.text.trim(),
        isCustom: isCustom,
      )..needWater = needWater;

      // TODO: Replace this with your repository call.
      // e.g., final addedPlant = await plantRepository.addPlant(newPlant);
      await Future.delayed(
        const Duration(seconds: 2),
      ); // simulate network delay

      // Clear fields after successful addition.
      nameController.clear();
      noteController.clear();
      plantClassController.clear();
      familyCommonController.clear();
      familyScientificController.clear();
      isCustom = false;
      needWater = false;
      errorMessage = null;
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    plantClassController.dispose();
    familyCommonController.dispose();
    familyScientificController.dispose();
    super.dispose();
  }
}
