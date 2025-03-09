import 'package:garden_app/services/supabase_service.dart';
import 'package:garden_app/repositories/auth_repository.dart';

class AuthRepositaryRemote implements AuthRepository {
  @override
  Future<String?> login(String email, String password) async {
    return await SupabaseService().login(email, password);
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<String?> register(String email, String password, String name, String surname) {
    // TODO: implement register
    throw UnimplementedError();
  }
  
  @override
  bool isLoggedIn() {
    // TODO: implement isLoggedIn
    throw UnimplementedError();
  }

}