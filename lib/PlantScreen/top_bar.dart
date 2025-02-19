import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlantTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String plantName;

  const PlantTopBar({super.key, required this.plantName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green[100],
      elevation: 0,
      title: Text(
        plantName,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: SvgPicture.asset("assets/svgs/back.svg", height: 24),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset("assets/svgs/menu.svg", height: 24),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
