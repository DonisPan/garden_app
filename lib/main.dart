import 'package:flutter/material.dart';
import 'package:garden_app/pages/plant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const PlantScreen(
        plantName: "Japanese Maple",
        imagePath:
            "https://static.vecteezy.com/system/resources/previews/013/743/890/non_2x/pixel-art-tree-icon-png.png",
      ),
    );
  }
}
