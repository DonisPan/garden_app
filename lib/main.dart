import 'package:flutter/material.dart';
import 'package:garden_app/models/global.dart';
import 'package:garden_app/models/supabase.dart';
import 'package:garden_app/views/home.dart';
import 'package:garden_app/views/login.dart';
import 'package:garden_app/views/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Global();
  // Global().delUserSession();
  await SupabaseService().initialize();

  // SupabaseService().register('denvas002@gmail.com', 'hello123');
  // SupabaseService().login('denvas002@gmail.com', 'hello123');
  // SupabaseService().logout();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Garden App',
      theme: ThemeData(fontFamily: 'AtkinsonHyperlegiableMono'),
      home: MainPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MainPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
