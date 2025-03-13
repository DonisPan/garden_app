import 'package:flutter/material.dart';
import 'package:garden_app/repositories/auth_remote_repository.dart';
import 'package:garden_app/services/global.dart';
import 'package:garden_app/services/supabase_service.dart';
import 'package:garden_app/views/home.dart';
import 'package:garden_app/views/login.dart';
import 'package:garden_app/views/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AuthRemoteRepository authRemoteRepositary;

  Global();
  // Global().delUserSession();
  await SupabaseService.initialize();

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
      home: HomePage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
