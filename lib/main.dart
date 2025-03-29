import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/repositories/auth_remote_repository.dart';
import 'package:garden_app/repositories/auth_repository.dart';
import 'package:garden_app/repositories/plant_remote_repository.dart';
import 'package:garden_app/repositories/plant_repository.dart';
import 'package:garden_app/services/global.dart';
import 'package:garden_app/services/supabase_service.dart';
import 'package:garden_app/views/add_plant.dart';
import 'package:garden_app/views/home.dart';
import 'package:garden_app/views/login.dart';
import 'package:garden_app/views/profile.dart';
import 'package:garden_app/views/register.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  Global();
  await SupabaseService.initialize();

  final authRepository = AuthRemoteRepository();
  final plantRepository = PlantRemoteRepository();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('sk')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          Provider<AuthRepository>.value(value: authRepository),
          Provider<PlantRepository>.value(value: plantRepository),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Garden App',
      // theme: ThemeData(fontFamily: 'AtkinsonHyperlegiableMono'),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: Global.isAuthorized() ? HomePage() : LoginPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/addPlant': (context) => const AddPlantPage(),
        '/plantDetail': (context) => const AddPlantPage(),
      },
    );
  }
}
