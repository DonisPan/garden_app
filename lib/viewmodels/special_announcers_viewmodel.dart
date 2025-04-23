import 'package:flutter/material.dart';
import 'package:garden_app/models/admin_announcer.dart';
import 'package:garden_app/repositories/plant_repository.dart';

/// ViewModel for SpecialAnnouncersPage
class SpecialAnnouncersViewModel extends ChangeNotifier {
  /// List of announcements to display
  final PlantRepository plantRepository;
  List<AdminAnnouncer> announcers;

  SpecialAnnouncersViewModel({
    required this.plantRepository,
    required this.announcers,
  });

  // Future<void> fetchAnnouncers() async {
  //   announcers = await plantRepository.getSpecialAnnouncers();
  //   notifyListeners();
  // }

  /// Number of announcements
  int get count => announcers.length;

  /// Get announcement at index
  AdminAnnouncer announcerAt(int index) => announcers[index];
}
