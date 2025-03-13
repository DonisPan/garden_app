import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Global {
  static final Global _instance = Global._internal();
  final FlutterSecureStorage secureStorage =
      FlutterSecureStorage(); // Create secure storage

  bool authorized = false;

  factory Global() => _instance;

  Global._internal();

  static void authorize() {
    _instance.authorized = true;
  }

  static void unAuthorize() {
    _instance.authorized = false;
  }

  static bool isAuthorized() {
    return _instance.authorized;
  }

  Future<void> setUserSession(String token, int id) async {
    await secureStorage.write(key: 'sessionToken', value: token);
    await secureStorage.write(key: 'userId', value: id.toString());
  }

  Future<String?> getUserSession() async {
    final refreshToken = await secureStorage.read(key: 'sessionToken');
    if (refreshToken == null) {
      return null;
    }
    return refreshToken;
  }

  Future<int?> getUserId() async {
    final idStr = await secureStorage.read(key: 'userId');
    if (idStr == null) {
      return null;
    }
    return int.tryParse(idStr);
  }

  Future<void> delUserSession() async {
    await secureStorage.delete(key: 'sessionToken');
    await secureStorage.delete(key: 'userId');
  }
}
