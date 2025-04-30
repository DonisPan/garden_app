import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/models/admin_announcer.dart';
import 'package:garden_app/repositories/plant_repository.dart';
import 'package:garden_app/viewmodels/special_announcers_viewmodel.dart';
import 'package:garden_app/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class SpecialAnnouncersPage extends StatelessWidget {
  final List<AdminAnnouncer> announcers;
  const SpecialAnnouncersPage({super.key, required this.announcers});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SpecialAnnouncersViewModel>(
      create:
          (_) => SpecialAnnouncersViewModel(
            plantRepository: Provider.of<PlantRepository>(
              context,
              listen: false,
            ),
            announcers: announcers,
          ),
      child: Consumer<SpecialAnnouncersViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: TopBar(
              title: 'announcers.title'.tr(),
              leftIcon: 'assets/svgs/back.svg',
              onLeftButtonTap: () => Navigator.of(context).pop(),
              showRightButton: false,
            ),
            body:
                viewModel.count == 0
                    ? Center(
                      child: Text(
                        'announcers.none'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: viewModel.count,
                      itemBuilder: (context, index) {
                        final ann = viewModel.announcerAt(index);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ann.plantNames.join(', '),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ann.message,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          );
        },
      ),
    );
  }
}
