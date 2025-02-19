import 'package:flutter/material.dart';
import 'package:garden_app/PlantScreen/bottom_bar.dart';
import 'package:garden_app/PlantScreen/top_bar.dart';

class PlantScreen extends StatelessWidget {
  final String plantName;
  final String imagePath;

  const PlantScreen({
    super.key,
    required this.plantName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      // Top Bar
      appBar: PlantTopBar(plantName: plantName),
      body: Column(
        children: [
          // Plant Image
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Hero(
                tag: plantName,
                child: Image.network(imagePath, fit: BoxFit.contain),
              ),
            ),
          ),

          // Bottom Bar
          const PlantBottomBar(),
        ],
      ),
    );
  }
}
