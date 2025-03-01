import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Global {
  static final Global _instance = Global._internal();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage(); // Create secure storage

  bool authorized = false;

  factory Global() =>_instance;

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

  Future<void> setUserSession(String token) async => await secureStorage.write(key: 'sessionToken', value: token);

  Future<String?> getUserSession() async => await secureStorage.read(key: 'sessionToken');

  Future<void> delUserSession() async => await secureStorage.delete(key: 'sessionToken');
}