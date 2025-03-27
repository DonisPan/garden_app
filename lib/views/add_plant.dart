import 'package:flutter/material.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/widgets/top_bar.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/viewmodels/add_plant_viewmodel.dart';
import 'package:garden_app/repositories/plant_remote_repository.dart';

class AddPlantPage extends StatelessWidget {
  const AddPlantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddPlantViewModel>(
      create:
          (_) => AddPlantViewModel(plantRepository: PlantRemoteRepository()),
      child: Consumer<AddPlantViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: TopBar(
              title: "Add Plant",
              leftIcon: 'assets/svgs/back.svg',
              onLeftButtonTap: () => Navigator.pop(context),
              // You can set a right icon and its action if needed.
              showRightButton: false,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  const SizedBox(height: 10),
                  // Name field: dropdown if not custom, text field if custom.
                  viewModel.isCustom
                      ? _buildTextField(
                        controller: viewModel.customNameController,
                        label: "Enter your custom plant name",
                        readOnly: false,
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDropdown<Plant>(
                            label: "Choose plant",
                            value: viewModel.selectedPlant,
                            items: viewModel.plants,
                            getItemLabel: (plant) => plant.name,
                            onChanged: (Plant? newValue) {
                              viewModel.selectedPlant = newValue;
                              viewModel.notifyListeners();
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            controller: viewModel.customNameController,
                            label: "Or enter your custom plant name",
                            readOnly: false,
                          ),
                        ],
                      ),
                  const SizedBox(height: 10),
                  // Note field: editable for custom, auto-filled and read-only otherwise.
                  viewModel.isCustom
                      ? _buildTextField(
                        controller: viewModel.noteController,
                        label: "Note (optional)",
                        readOnly: false,
                      )
                      : _buildTextField(
                        controller: TextEditingController(
                          text: viewModel.selectedPlant?.note,
                        ),
                        label: "Note (auto-filled)",
                        readOnly: true,
                      ),
                  const SizedBox(height: 10),
                  // Plant Class: dropdown for custom, label for non-custom.
                  viewModel.isCustom
                      ? _buildDropdown<PlantClass>(
                        label: "Plant Class",
                        value: viewModel.selectedPlantClass,
                        items: viewModel.classes,
                        getItemLabel: (pc) => pc.name ?? '',
                        onChanged: (PlantClass? newValue) {
                          viewModel.selectedPlantClass = newValue;
                          viewModel.notifyListeners();
                        },
                      )
                      : _buildTextField(
                        controller: TextEditingController(
                          text: viewModel.selectedPlant?.plantClass?.name ?? '',
                        ),
                        label: "Plant Class",
                        readOnly: true,
                      ),
                  const SizedBox(height: 10),
                  // Family: dropdown for custom, label for non-custom.
                  viewModel.isCustom
                      ? _buildDropdown<PlantFamily>(
                        label: "Family (Common & Scientific)",
                        value: viewModel.selectedPlantFamily,
                        items: viewModel.families,
                        getItemLabel: (pf) => pf.nameCommon ?? '',
                        onChanged: (PlantFamily? newValue) {
                          viewModel.selectedPlantFamily = newValue;
                          viewModel.notifyListeners();
                        },
                      )
                      : _buildTextField(
                        controller: TextEditingController(
                          text:
                              viewModel.selectedPlant != null
                                  ? "${viewModel.selectedPlant?.plantFamily?.nameCommon ?? ''} | ${viewModel.selectedPlant?.plantFamily?.nameScientific ?? ''}"
                                  : "",
                        ),
                        label: "Family (Common & Scientific)",
                        readOnly: true,
                      ),
                  const SizedBox(height: 10),
                  // Custom plant checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: viewModel.isCustom,
                        onChanged: (bool? value) {
                          if (value != null) {
                            viewModel.isCustom = value;
                            viewModel.notifyListeners();
                          }
                        },
                      ),
                      const Text(
                        "Custom Plant",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Add Plant button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.black,
                      ),
                      onPressed:
                          viewModel.isLoading
                              ? null
                              : () => viewModel.addPlant(),
                      child:
                          viewModel.isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Add Plant",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Reusable text field builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String? label,
    bool readOnly = false,
  }) {
    final textField = TextField(
      controller: controller,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: readOnly ? IgnorePointer(child: textField) : textField,
    );
  }

  // Reusable dropdown builder
  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) getItemLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
        items:
            items.map((option) {
              return DropdownMenuItem<T>(
                value: option,
                child: Text(
                  getItemLabel(option),
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
        onChanged: onChanged,
        isExpanded: true,
        style: const TextStyle(color: Colors.black),
        dropdownColor: Colors.white,
      ),
    );
  }
}
