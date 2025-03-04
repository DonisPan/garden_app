import 'package:flutter/material.dart';
import 'package:garden_app/models/global.dart';
import 'package:garden_app/models/supabase.dart';
import 'package:garden_app/screens/home.dart';

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
      theme: ThemeData(fontFamily: 'AtkinsonHyperlegiableMono'),
      home: MainPage(),
    );
  }
}
