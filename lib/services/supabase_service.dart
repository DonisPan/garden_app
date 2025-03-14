import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/models/statistics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:garden_app/services/global.dart';
import 'package:garden_app/models/profile.dart';

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
    final id = await Global().getUserId();
    print('Session: $session, id: $id');
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
        final authId = response.user!.id;
        final id =
            await Supabase.instance.client
                .from('ga_users')
                .select('id')
                .eq('auth_id', authId)
                .single();

        final token = response.session?.refreshToken;
        await Global().setUserSession(token!, id['id'] as int);
        Global.authorize();
        return null;
      } else {
        throw Exception('No Session Found!');
      }
    } catch (error) {
      return "Wrong email or password, ${error.toString()}";
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

  Future<Profile> getUser({required int userId}) async {
    try {
      final response =
          await Supabase.instance.client
              .from('ga_users')
              .select('name, surname')
              .eq('id', userId)
              .maybeSingle();

      final data = response as Map<String, dynamic>;

      return Profile(
        name: data['name'] as String,
        surname: data['surname'] as String,
      );
    } catch (error) {
      print('error fetching user: $error');
      rethrow;
    }
  }

  Future<List<Plant>> getPlants({required int userId}) async {
    try {
      final response = await Supabase.instance.client
          .from('ga_user_plants')
          .select('name, plant_id:ga_plant(*, plant_family(*))')
          .eq('user_id', userId);

      final data = response as List<dynamic>;

      final plants =
          data.map((row) {
            final plantData = row['plant_id'] as Map<String, dynamic>;
            final familyData =
                plantData['plant_family'] as Map<String, dynamic>?;

            return Plant(
              id: plantData['id'] as int,
              name:
                  row['name'] as String? ??
                  (plantData['name'] as String? ?? 'Name missing!'),
              note: plantData['note'] as String?,
              plantClass: plantData['class'] as String? ?? 'Class missing!',
              familyCommon:
                  familyData?['name_common'] as String? ??
                  'Family common missing!',
              familyScientific:
                  familyData?['name_scientific'] as String? ??
                  'Family scientfic missing!',
              isCustom: plantData['is_custom'] as bool,
            );
          }).toList();

      return plants;
    } catch (error) {
      print('error fetching plants: $error');
      rethrow;
    }
  }

  Future<Statistics> getStatistics(int userId) async {
    try {
      final response = await Supabase.instance.client
          .from('ga_user_plants')
          .select('plant_id')
          .eq('user_id', userId);

      final data = response as List<dynamic>;
      return Statistics(parPlantCount: data.length);
    } catch (error) {
      print('error fetching statistics: $error');
      rethrow;
    }
  }
}
