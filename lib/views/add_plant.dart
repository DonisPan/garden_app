import 'package:easy_localization/easy_localization.dart';
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
              title: 'add_plant.title'.tr(),
              leftIcon: 'assets/svgs/back.svg',
              onLeftButtonTap: () => Navigator.pop(context),
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
                  // plant name
                  viewModel.isCustom
                      ? _buildTextField(
                        controller: viewModel.customNameController,
                        label: 'add_plant.custom_name'.tr(),
                        readOnly: false,
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDropdown<Plant>(
                            label: 'add_plant.choose_plant'.tr(),
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
                            label: 'add_plant.custom_name_optional'.tr(),
                            readOnly: false,
                          ),
                        ],
                      ),
                  const SizedBox(height: 10),

                  // note
                  viewModel.isCustom
                      ? _buildTextField(
                        controller: viewModel.noteController,
                        label: 'add_plant.note_optional'.tr(),
                        readOnly: false,
                      )
                      : _buildTextField(
                        controller: TextEditingController(
                          text: viewModel.selectedPlant?.note,
                        ),
                        label: 'add_plant.note'.tr(),
                        readOnly: true,
                      ),

                  const SizedBox(height: 10),
                  // plant class
                  viewModel.isCustom
                      ? _buildDropdown<PlantClass>(
                        label: 'add_plant.plant_class_optional'.tr(),
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
                        label: 'add_plant.plant_class'.tr(),
                        readOnly: true,
                      ),
                  const SizedBox(height: 10),
                  // plant family
                  viewModel.isCustom
                      ? _buildDropdown<PlantFamily>(
                        label: 'add_plant.plant_family_optional'.tr(),
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
                        label: 'add_plant.plant_family'.tr(),
                        readOnly: true,
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
                      Text(
                        'add_plant.custom_plant'.tr(),
                        style: TextStyle(color: Colors.black),
                      ),
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
                        backgroundColor: Colors.black,
                      ),
                      onPressed:
                          viewModel.isLoading
                              ? null
                              : () => viewModel.addPlant(context),
                      child:
                          viewModel.isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Text(
                                'add_plant.add_plant'.tr(),
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

  // text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String? label,
    bool readOnly = false,
    int minLines = 1,
    int maxLines = 80,
  }) {
    final textField = TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: TextInputType.multiline,
      minLines: minLines,
      maxLines: maxLines,
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

  // dropdown
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
