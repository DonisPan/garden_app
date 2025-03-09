import 'package:flutter/material.dart';
import 'package:garden_app/repositories/auth_repository.dart';
import 'package:garden_app/repositories/plant_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final PlantRepository plantRepository;
  final AuthRepository authRepositary;
  HomeViewModel(this.plantRepository, this.authRepositary);

  TextEditingController searchQueryController = TextEditingController();

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void updateSearchQuery(String query) {
    _searchQuery = query;

    notifyListeners();
  }

  void goToProfilePage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    searchQueryController.dispose();
    super.dispose();
  }
}