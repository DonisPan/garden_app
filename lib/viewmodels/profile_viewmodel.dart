import 'package:flutter/material.dart';
import 'package:garden_app/services/supabase_service.dart';

class ProfileViewModel extends ChangeNotifier {
  String firstName = 'TestName';
  String surname = 'TestSurname';

  int plantCount = 0;

  bool notificationsEnabled = false;

  void leftButton(BuildContext context) {
    Navigator.pop(context);
  }

  void rightButton(BuildContext context) {
    SupabaseService().logout();
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> fetchStatistics() async {
    notifyListeners();
  }

  Future<void> enableNotifications(bool enabled) async {
    notificationsEnabled = enabled;
    notifyListeners();
  }

  /// Stub: Update profile details.
  Future<void> updateProfile(String newFirstName, String newSurname) async {
    firstName = newFirstName;
    surname = newSurname;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
