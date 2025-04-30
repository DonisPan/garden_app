import 'package:flutter/material.dart';
import 'package:garden_app/models/admin_announcer.dart';
import 'package:garden_app/repositories/plant_repository.dart';

class SpecialAnnouncersViewModel extends ChangeNotifier {
  final PlantRepository plantRepository;
  List<AdminAnnouncer> announcers;

  SpecialAnnouncersViewModel({
    required this.plantRepository,
    required this.announcers,
  });

  int get count => announcers.length;

  AdminAnnouncer announcerAt(int index) => announcers[index];
}
