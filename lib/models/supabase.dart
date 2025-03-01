import 'package:garden_app/models/global.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  SupabaseService._internal();
  factory SupabaseService() => _instance;

  Future<void> initialize() async {
    await dotenv.load();

    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_KEY']!,
    );

    final session = await Global().getUserSession();
    print('Session: $session');
    if (session != null) {
      await Supabase.instance.client.auth.setSession(session);
      Global.authorize();
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);

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
    print('User logged out!');
  }

  Future<void> register(String email, String password) async {
      try {
      await Supabase.instance.client.auth.signUp(email: email, password: password);
    } catch (error) {
      print('Registration failed: $error');
    }
  }
}