import 'package:flutter/material.dart';
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
            appBar: AppBar(
              title: const Text("Add Plant"),
              backgroundColor: Colors.white,
              elevation: 0.0,
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
                  _buildTextField(viewModel.nameController, "Name *"),
                  const SizedBox(height: 10),
                  _buildTextField(viewModel.noteController, "Note (optional)"),
                  const SizedBox(height: 10),
                  _buildTextField(
                    viewModel.plantClassController,
                    "Plant Class *",
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    viewModel.familyCommonController,
                    "Family Common *",
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    viewModel.familyScientificController,
                    "Family Scientific *",
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
                      const Text("Custom Plant"),
                    ],
                  ),
                  // Need water switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Needs Water"),
                      Switch(
                        value: viewModel.needWater,
                        onChanged: (bool value) {
                          viewModel.needWater = value;
                          viewModel.notifyListeners();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Submit button
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

  Widget _buildTextField(TextEditingController controller, String label) {
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
      child: TextField(
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
      ),
    );
  }
}
