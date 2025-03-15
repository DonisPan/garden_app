import 'package:flutter/material.dart';
import 'package:garden_app/models/statistics.dart';
import 'package:garden_app/repositories/plant_repository.dart';
import 'package:garden_app/services/global.dart';
import 'package:garden_app/services/supabase_service.dart';
import 'package:garden_app/models/profile.dart';

class ProfileViewModel extends ChangeNotifier {
  Profile? user;
  final PlantRepository plantRepository;

  ProfileViewModel(this.plantRepository) {
    fetchUser();
    fetchStatistics();
  }

  Statistics? statistics;

  bool notificationsEnabled = false;

  void leftButton(BuildContext context) {
    Navigator.pop(context);
  }

  void rightButton(BuildContext context) {
    SupabaseService().logout();
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> fetchUser() async {
    final userId = await Global().getUserId();
    if (userId == null) {
      return;
    }
    user = await SupabaseService().getUser(userId: userId);
    notifyListeners();
  }

  Future<void> fetchStatistics() async {
    final userId = await Global().getUserId();
    if (userId == null) {
      return;
    }
    statistics = await plantRepository.getStatistics(userId);
    notifyListeners();
  }

  Future<void> enableNotifications(bool enabled) async {
    notificationsEnabled = enabled;
    notifyListeners();
  }
}
