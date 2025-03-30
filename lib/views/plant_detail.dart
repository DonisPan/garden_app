import 'dart:io';
import 'package:flutter/material.dart';
import 'package:garden_app/viewmodels/plant_detail_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/widgets/top_bar.dart';

class PlantDetailPage extends StatelessWidget {
  final Plant plant;
  const PlantDetailPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlantDetailViewModel>(
      create:
          (_) => PlantDetailViewModel(
            plant: plant,
            plantRepository: Provider.of(
              context,
              listen: false,
            ), // Provide your PlantRepository here
          ),
      child: Consumer<PlantDetailViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: TopBar(
              title: viewModel.plant.name,
              leftIcon: 'assets/svgs/back.svg',
              onLeftButtonTap: () => Navigator.pop(context),
              showRightButton: false,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plant Data Card
                  Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Name:', viewModel.plant.name),
                          _buildDetailRow(
                            'Note:',
                            viewModel.plant.note ?? 'No note',
                          ),
                          _buildDetailRow(
                            'Plant Class:',
                            viewModel.plant.plantClass?.name ?? 'Not specified',
                          ),
                          _buildDetailRow(
                            'Family:',
                            viewModel.plant.plantFamily == null
                                ? 'Not specified'
                                : '${viewModel.plant.plantFamily?.nameCommon ?? ''} | ${viewModel.plant.plantFamily?.nameScientific ?? ''}',
                          ),
                          _buildDetailRow(
                            'Custom Plant:',
                            viewModel.plant.isCustom ? 'Yes' : 'No',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Images Card
                  _buildImagesCard(viewModel.plantImages),
                  const SizedBox(height: 20),
                  // Buttons Row: Delete and Manage Notifications
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => viewModel.deletePlant(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Delete Plant",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              () => viewModel.manageNotifications(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Manage Notifications",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Add Image Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => viewModel.addImage(context),
                      icon: const Icon(Icons.add_a_photo, color: Colors.white),
                      label: const Text(
                        "Add Image",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              detail,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesCard(List<File> plantImages) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.black, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            plantImages.isEmpty
                ? const Center(
                  child: Text(
                    "No images added.",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                )
                : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      plantImages
                          .map(
                            (imageFile) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                imageFile,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          .toList(),
                ),
      ),
    );
  }
}
