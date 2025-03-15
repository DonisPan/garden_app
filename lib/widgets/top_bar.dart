import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onLeftButtonTap;
  final VoidCallback? onRightButtonTap;
  final bool showLeftButton;
  final bool showRightButton;
  final String? leftIcon;
  final String? rightIcon;

  const TopBar({
    super.key,
    this.title,
    this.onLeftButtonTap,
    this.onRightButtonTap,
    this.showLeftButton = true,
    this.showRightButton = true,
    this.leftIcon,
    this.rightIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? '',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: showLeftButton ? _buildLeftButton(context) : null,
      actions: showRightButton ? [_buildRightButton(context)] : [],
    );
  }

  Widget _buildLeftButton(BuildContext context) {
    return GestureDetector(
      onTap: onLeftButtonTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        width: 37,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 240, 239, 239),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          leftIcon ?? 'assets/svgs/error.svg',
          height: 25,
        ),
      ),
    );
  }

  Widget _buildRightButton(BuildContext context) {
    return GestureDetector(
      onTap: onRightButtonTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        width: 37,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 240, 239, 239),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          rightIcon ?? 'assets/svgs/error.svg',
          height: 25,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
