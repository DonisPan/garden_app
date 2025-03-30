import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
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
            plantRepository: Provider.of(context, listen: false),
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
                  // plant details card
                  _buildDetailsCard(viewModel),
                  const SizedBox(height: 20),
                  // images card
                  _buildImagesCard(context, viewModel.plantImages),
                  const SizedBox(height: 20),
                  // buttons
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
                          child: Text(
                            "plant_detail.delete_plant".tr(),
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
                          child: Text(
                            "plant_detail.manage_notifications".tr(),
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // add image button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => viewModel.addImage(context),
                      icon: const Icon(Icons.add_a_photo, color: Colors.white),
                      label: Text(
                        "plant_detail.add_image".tr(),
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

  Card _buildDetailsCard(PlantDetailViewModel viewModel) {
    return Card(
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
            _buildDetailRow(
              'plant_detail.details.name'.tr(),
              viewModel.plant.name,
            ),
            _buildDetailRow(
              'plant_detail.details.note'.tr(),
              viewModel.plant.note ?? 'plant_detail.details.no_note'.tr(),
            ),
            _buildDetailRow(
              'plant_detail.details.plant_class'.tr(),
              viewModel.plant.plantClass?.name ??
                  'plant_detail.details.no_plant_class'.tr(),
            ),
            _buildDetailRow(
              'plant_detail.details.plant_family'.tr(),
              viewModel.plant.plantFamily == null
                  ? 'plant_detail.details.no_plant_family'.tr()
                  : '${viewModel.plant.plantFamily?.nameCommon ?? ''} | ${viewModel.plant.plantFamily?.nameScientific ?? ''}',
            ),
            _buildDetailRow(
              'plant_detail.details.custom_plant'.tr(),
              viewModel.plant.isCustom
                  ? 'plant_detail.details.yes'.tr()
                  : 'plant_detail.details.no'.tr(),
            ),
          ],
        ),
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

  Widget _buildImagesCard(BuildContext context, List<File> plantImages) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.black, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          // max height
          constraints: const BoxConstraints(maxHeight: 210),
          child:
              plantImages.isEmpty
                  ? Center(
                    child: Text(
                      "plant_detail.no_images".tr(),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  )
                  : SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          plantImages.map((imageFile) {
                            return GestureDetector(
                              onTap:
                                  () => _showExpandedImage(context, imageFile),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  imageFile,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
        ),
      ),
    );
  }

  Future<void> _showExpandedImage(BuildContext context, File imageFile) async {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(child: InteractiveViewer(child: Image.file(imageFile))),
        );
      },
    );
  }
}
