import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/repositories/auth_remote_repository.dart';
import 'package:garden_app/repositories/auth_repository.dart';
import 'package:garden_app/repositories/plant_remote_repository.dart';
import 'package:garden_app/repositories/plant_repository.dart';
import 'package:garden_app/services/global.dart';
import 'package:garden_app/services/local_notification_service.dart';
import 'package:garden_app/services/supabase_service.dart';
import 'package:garden_app/views/add_plant.dart';
import 'package:garden_app/views/home.dart';
import 'package:garden_app/views/login.dart';
import 'package:garden_app/views/profile.dart';
import 'package:garden_app/views/register.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized(); // for different languages

  Global();
  await SupabaseService.initialize(); // for remote

  final authRepository = AuthRemoteRepository();
  final plantRepository = PlantRemoteRepository();

  // Initialize notifications service
  await LocalNotificationsService.initialize(
    onDidReceiveNotificationResponse: (response) {
      // This handles when user taps on a notification
      print('Notification tapped!');
      print('ID: ${response.id}');
      print('Payload: ${response.payload}');

      // You can navigate to specific screens based on the payload
      if (response.payload == 'special') {
        // Navigator.push(...) to specific screen
      }
    },
  );

  final bool granted = await LocalNotificationsService.requestPermissions();
  print('Notification permissions granted: $granted');

  // Check if app was launched via notification
  final launchDetails =
      await LocalNotificationsService.getNotificationAppLaunchDetails();
  if (launchDetails?.didNotificationLaunchApp ?? false) {
    print('App launched via notification');
    print('Notification ID: ${launchDetails?.notificationResponse?.id}');
    print(
      'Notification Payload: ${launchDetails?.notificationResponse?.payload}',
    );
  }

  await LocalNotificationsService.showNotification(
    body: 'Application started',
    id: 1,
    title: 'Notification test',
  );

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
    context.setLocale(const Locale('sk')); // set locale to Slovak
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Garden App',
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
