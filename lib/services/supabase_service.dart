import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:garden_app/services/global.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  SupabaseService._internal();
  factory SupabaseService() => _instance;

  static Future<void> initialize() async {
    await dotenv.load();

    // initialize supabase
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_KEY']!,
    );

    // try to load refresh token from secure storage and set user session
    final session = await Global().getUserSession();
    print('Session: $session');
    if (session != null) {
      await Supabase.instance.client.auth.setSession(session);
      Global.authorize();
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final token = response.session?.refreshToken;
        await Global().setUserSession(token!);
        Global.authorize();
        return null;
      } else {
        throw Exception('No Session Found!');
      }
    } catch (error) {
      return "Wrong email or password";
    }
  }

  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();

      await Global().delUserSession();
      Global.unAuthorize();
    } catch (error) {
      print('Logout failed: $error');
    }
  }

  Future<String?> register(
    String email,
    String password,
    String name,
    String surname,
  ) async {
    try {
      var result = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      ); // register into supabase auth
      var userId = result.user?.id;

      if (userId == null) {
        return 'Registration failed';
      }

      await Supabase.instance.client.from('ga_users').insert(
        {'auth_id': userId, 'name': name, 'surname': surname},
      ); // after succesfull registration insert additional data into users table
    } catch (error) {
      return 'Could not instert additional data';
    }
    return null;
  }
}
