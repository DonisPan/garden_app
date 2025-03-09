import 'package:garden_app/services/supabase_service.dart';
import 'package:garden_app/repositories/auth_repository.dart';

class AuthRemoteRepositary implements AuthRepository {
  @override
  Future<String?> login(String email, String password) async {
    return await SupabaseService().login(email, password);
  }

  @override
  Future<void> logout() async{
    await SupabaseService().logout();
  }

  @override
  Future<String?> register(String email, String password, String name, String surname) async{
    return await SupabaseService().register(email, password, name, surname);
  }
  
  @override
  bool isLoggedIn() {
    // TODO: implement isLoggedIn
    throw UnimplementedError();
  }

}