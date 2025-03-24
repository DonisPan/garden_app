import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/repositories/plant_remote_repository.dart';

class AddPlantViewModel extends ChangeNotifier {
  final PlantRemoteRepository plantRepository;

  // For non-custom plants (dropdown) for Name
  List<String> plantNames = ['Rose', 'Tulip', 'Sunflower']; // Example options
  String? selectedPlantName;

  // For custom plant names (text field)
  final TextEditingController customNameController = TextEditingController();

  // For Plant Class dropdown (instead of a text field)
  List<String> plantClasses = ['Herb', 'Shrub', 'Tree', 'Climber'];
  String? selectedPlantClass;

  // For Family dropdown (combined common & scientific)
  List<String> families = [
    'Rosaceae / Rose',
    'Fabaceae / Bean',
    'Solanaceae / Nightshade',
    'Poaceae / Grass',
  ];
  String? selectedFamily;

  // Other controllers (if needed, for note etc.)
  final TextEditingController noteController = TextEditingController();

  // Additional properties.
  bool isCustom = false;
  bool needWater = false;

  // For error and loading states.
  String? errorMessage;
  bool isLoading = false;

  AddPlantViewModel({required this.plantRepository});

  /// Validate the form fields.
  String? _validate() {
    // Use custom name if custom plant, otherwise use the selected plant name.
    final name =
        isCustom
            ? customNameController.text.trim()
            : (selectedPlantName ?? '').trim();
    // For plant class, use selectedPlantClass
    final plantClass = selectedPlantClass;
    // For family, you can use selectedFamily (or split it into common and scientific as needed).
    final family = selectedFamily;

    if (name.isEmpty) {
      return "Name is required.";
    }
    if (plantClass == null || plantClass.isEmpty) {
      return "Plant class is required.";
    }
    if (family == null || family.isEmpty) {
      return "Family selection is required.";
    }
    return null;
  }

  /// Stub method: Add a new plant.
  Future<void> addPlant() async {
    errorMessage = _validate();
    if (errorMessage != null) {
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      // Use the custom name if isCustom, otherwise use the selected name.
      final name =
          isCustom ? customNameController.text.trim() : selectedPlantName!;

      // For family, split the combined string into common and scientific parts.
      String familyCommon = '';
      String familyScientific = '';
      if (selectedFamily != null) {
        final parts = selectedFamily!.split(' / ');
        familyCommon = parts[0];
        familyScientific = parts.length > 1 ? parts[1] : '';
      }

      final newPlant = Plant(
        id: 0, // Temporary ID; repository assigns the actual id.
        name: name,
        note:
            noteController.text.trim().isEmpty
                ? null
                : noteController.text.trim(),
        plantClass: selectedPlantClass!,
        familyCommon: familyCommon,
        familyScientific: familyScientific,
        isCustom: isCustom,
      )..needWater = needWater;

      // TODO: Replace with your actual repository call.
      await plantRepository.addPlant(newPlant);

      // Clear fields upon success.
      if (isCustom) {
        customNameController.clear();
      } else {
        selectedPlantName = null;
      }
      noteController.clear();
      selectedPlantClass = null;
      selectedFamily = null;
      isCustom = false;
      needWater = false;
      errorMessage = null;
    } catch (error) {
      errorMessage = "Error adding plant: $error";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    customNameController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
