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
    print('Trying session: $session, user id: $id');
    if (session != null) {
      try {
        await Supabase.instance.client.auth.setSession(session);
        Global.authorize();
      } catch (error) {
        print('Error setting session: $error');
        await Global().delUserSession();
        Global.unAuthorize();
      }
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
      rethrow;
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
          .select('name, plant_id:ga_plant(*, plant_family(*), plant_class(*))')
          .eq('user_id', userId);

      final data = response as List<dynamic>;

      final plants =
          data.map((row) {
            final plantData = row['plant_id'] as Map<String, dynamic>;
            final classData = plantData['plant_class'] as Map<String, dynamic>?;
            final familyData =
                plantData['plant_family'] as Map<String, dynamic>?;

            return Plant(
              id: plantData['id'] as int,
              name:
                  row['name'] as String? ??
                  (plantData['name'] as String? ?? 'Name missing!'),
              note: plantData['note'] as String?,
              plantClass:
                  classData != null
                      ? PlantClass(
                        id: classData['id'] as int,
                        name: classData['name'],
                      )
                      : null,
              plantFamily:
                  familyData != null
                      ? PlantFamily(
                        id: familyData['id'],
                        nameCommon: familyData['name_common'],
                        nameScientific: familyData['name_scientific'],
                      )
                      : null,
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

  Future<List<Plant>> getAllPlants() async {
    try {
      final response = await Supabase.instance.client
          .from('ga_plant')
          .select('*, plant_family(*), plant_class(*)')
          .eq('is_custom', false);

      final data = response as List<dynamic>;

      final plants =
          data.map((row) {
            final classData = row['plant_class'] as Map<String, dynamic>?;
            final familyData = row['plant_family'] as Map<String, dynamic>?;

            return Plant(
              id: row['id'] as int,
              name: row['name'] as String,
              note: row['note'] as String?,
              plantClass:
                  classData != null
                      ? PlantClass(
                        id: classData['id'] as int,
                        name: classData['name'],
                      )
                      : null,
              plantFamily:
                  familyData != null
                      ? PlantFamily(
                        id: familyData['id'],
                        nameCommon: familyData['name_common'],
                        nameScientific: familyData['name_scientific'],
                      )
                      : null,
              isCustom: row['is_custom'] as bool,
            );
          }).toList();

      return plants;
    } catch (error) {
      print('error fetching plants: $error');
      rethrow;
    }
  }

  Future<List<PlantClass>> getClasses() async {
    try {
      final response = await Supabase.instance.client
          .from('plant_class')
          .select('*');

      final data = response as List<dynamic>;

      final classes =
          data.map((row) {
            return PlantClass(
              id: row['id'] as int,
              name: row['name'] as String,
            );
          }).toList();

      return classes;
    } catch (error) {
      print('error fetching classes: $error');
      rethrow;
    }
  }

  Future<List<PlantFamily>> getFamilies() async {
    try {
      final response = await Supabase.instance.client
          .from('plant_family')
          .select('*');

      final data = response as List<dynamic>;

      final families =
          data.map((row) {
            return PlantFamily(
              id: row['id'] as int,
              nameCommon: row['name_common'] as String,
              nameScientific: row['name_scientific'] as String,
            );
          }).toList();

      return families;
    } catch (error) {
      print('error fetching classes: $error');
      rethrow;
    }
  }

  Future<String?> addPlant(String? name, {required id}) async {
    final userId = await Global().getUserId();
    if (name == '') {
      name = null;
    }
    try {
      final response = await Supabase.instance.client
          .from('ga_user_plants')
          .insert({'user_id': userId, 'plant_id': id, 'name': name});
      return response.toString();
    } catch (error) {
      return error.toString();
    }
  }

  Future<String?> addCustomPlant(
    String name,
    String? note,
    int? plantClass,
    int? plantFamily,
  ) async {
    final userId = await Global().getUserId();
    try {
      final plantResponse =
          await Supabase.instance.client
              .from('ga_plant')
              .insert({
                'name': name,
                'note': note,
                'class': plantClass,
                'family': plantFamily,
                'is_custom': true,
              })
              .select('id')
              .single();
      final plantId = plantResponse['id'] as int;

      final userPlantResponse = await Supabase.instance.client
          .from('ga_user_plants')
          .insert({'user_id': userId, 'plant_id': plantId});
      return userPlantResponse.toString();
    } catch (error) {
      return error.toString();
    }
  }
}
