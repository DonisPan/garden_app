abstract class AuthRepository {
  Future<String?> login(String email, String password);
  Future<void> logout();
  Future<String?> register(
    String email,
    String password,
    String name,
    String surname,
  );
}
