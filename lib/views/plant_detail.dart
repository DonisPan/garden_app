import 'package:flutter/material.dart';
import 'package:garden_app/repositories/plant_repository.dart';
import 'package:garden_app/viewmodels/plant_data_viewmodel.dart';
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
            plantRepository: Provider.of<PlantRepository>(
              context,
              listen: false,
            ),
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
                  _buildDetailRow('Name:', viewModel.plant.name),
                  _buildDetailRow('Note:', viewModel.plant.note ?? 'No note'),
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
                  const SizedBox(height: 20),
                  // Buttons Row
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, String detail) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
}
