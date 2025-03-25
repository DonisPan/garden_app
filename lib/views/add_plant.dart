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
              title: 'Add plant',
              leftIcon: 'assets/svgs/back.svg',
              onLeftButtonTap: () => viewModel.leftButton(context),
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
                  // name field or dropdown
                  viewModel.isCustom
                      ? _buildTextField(
                        viewModel.customNameController,
                        "Enter your custom plant name",
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPlantDropdown(
                            label: "Choose or make a custom plant",
                            value: viewModel.selectedPlant,
                            items: viewModel.plants,
                            onChanged: (Plant? newValue) {
                              viewModel.selectedPlant = newValue;
                              viewModel.notifyListeners();
                            },
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            viewModel.customNameController,
                            "Enter your custom plant name",
                          ),
                        ],
                      ),

                  const SizedBox(height: 10),
                  // note field
                  viewModel.isCustom
                      ? _buildTextField(
                        viewModel.noteController,
                        "Note (optional)",
                      )
                      : _buildLabel(viewModel.selectedPlant?.note),

                  const SizedBox(height: 10),
                  // plant class dropdown
                  viewModel.isCustom
                      ? _buildClassDropdown(
                        label: "Plant Class",
                        value: viewModel.selectedPlantClass,
                        items: viewModel.classes,
                        onChanged: (PlantClass? newValue) {
                          viewModel.selectedPlantClass = newValue;
                          viewModel.notifyListeners();
                        },
                      )
                      : _buildLabel(viewModel.selectedPlant?.plantClass?.name),

                  const SizedBox(height: 10),
                  // family dropdown
                  viewModel.isCustom
                      ? _buildFamilyDropdown(
                        label: "Family (Common & Scientific)",
                        value: viewModel.selectedPlantFamily,
                        items: viewModel.families,
                        onChanged: (PlantFamily? newValue) {
                          viewModel.selectedPlantFamily = newValue;
                          viewModel.notifyListeners();
                        },
                      )
                      : _buildLabel(
                        "${viewModel.selectedPlant?.plantFamily?.nameCommon ?? ''} | ${viewModel.selectedPlant?.plantFamily?.nameScientific ?? ''}",
                      ),
                  const SizedBox(height: 10),
                  // custom plant check box
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
                      const Text("Custom Plant"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // add plant button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
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
                                style: TextStyle(fontSize: 16),
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

  Widget _buildTextField(TextEditingController controller, String? label) {
    Widget textField = TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 216, 216, 216),
            blurRadius: 30,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: textField,
    );
  }

  Widget _buildLabel(String? label) {
    Widget textField = TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );

    textField = IgnorePointer(child: textField);

    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 216, 216, 216),
            blurRadius: 30,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: textField,
    );
  }

  Widget _buildPlantDropdown({
    required String label,
    required Plant? value,
    required List<Plant> items,
    required ValueChanged<Plant?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 216, 216, 216),
            blurRadius: 30,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: DropdownButtonFormField<Plant>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        items:
            items.map((option) {
              return DropdownMenuItem<Plant>(
                value: option,
                child: Text(option.name),
              );
            }).toList(),
        onChanged: onChanged,
        isExpanded: true,
      ),
    );
  }

  Widget _buildClassDropdown({
    required String label,
    required PlantClass? value,
    required List<PlantClass> items,
    required ValueChanged<PlantClass?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 216, 216, 216),
            blurRadius: 30,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: DropdownButtonFormField<PlantClass>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        items:
            items.map((option) {
              return DropdownMenuItem<PlantClass>(
                value: option,
                child: Text(option.name!),
              );
            }).toList(),
        onChanged: onChanged,
        isExpanded: true,
      ),
    );
  }

  Widget _buildFamilyDropdown({
    required String label,
    required PlantFamily? value,
    required List<PlantFamily> items,
    required ValueChanged<PlantFamily?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 216, 216, 216),
            blurRadius: 30,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: DropdownButtonFormField<PlantFamily>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        items:
            items.map((option) {
              return DropdownMenuItem<PlantFamily>(
                value: option,
                child: Text(option.nameCommon!),
              );
            }).toList(),
        onChanged: onChanged,
        isExpanded: true,
      ),
    );
  }
}
