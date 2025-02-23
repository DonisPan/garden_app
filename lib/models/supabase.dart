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

  Future<void> login(String email, String password) async {
    try {
      await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);

      final session = await Supabase.instance.client.auth.currentSession;
      if (session != null) {
        final token = session.refreshToken;
        await Global().setUserSession(token!);
        Global.authorize();
      } else {
        throw Exception('No Session Found!');
      }      
    } catch (error) {
      print('Login failed: $error');
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