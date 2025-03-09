import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garden_app/repositories/auth_remote_repositary.dart';
import 'package:garden_app/services/global.dart';
import 'package:garden_app/services/supabase_service.dart';
import 'package:garden_app/views/login.dart';
import 'package:garden_app/views/home.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Hello World',
        style: TextStyle(
          color: Global().authorized ? Colors.black : Colors.red,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: leftButton(context),
      actions: [rightButton()],
    );
  }

  Widget leftButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        leftButtonRedirect(context);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 240, 239, 239),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          'assets/svgs/profile.svg',
          height: 25,
        ),
      ),
    );
  }

  Future<void> leftButtonRedirect(BuildContext context) {
    if (Global.isAuthorized()) {
      AuthRepositaryRemote().logout();
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        );
    } else {
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        );
    }
  }

  Widget rightButton() {
    return GestureDetector(
      onTap: () {
        print("Right Button Pressed!");
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        width: 37,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 240, 239, 239),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          'assets/svgs/menu.svg',
          height: 20,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
