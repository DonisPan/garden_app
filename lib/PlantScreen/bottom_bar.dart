import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlantBottomBar extends StatelessWidget {
  const PlantBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomButton("assets/svgs/drop.svg", "Water"),
          _bottomButton("assets/icons/sun.svg", "Light"),
          _bottomButton("assets/icons/soil.svg", "Soil"),
        ],
      ),
    );
  }

  Widget _bottomButton(String iconPath, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(iconPath, height: 40),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
