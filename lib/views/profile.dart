import 'package:flutter/material.dart';
import 'package:garden_app/repositories/plant_repository.dart';
import 'package:garden_app/widgets/top_bar.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewModel>(
      create:
          (_) => ProfileViewModel(
            plantRepository: Provider.of<PlantRepository>(
              context,
              listen: false,
            ),
          ),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.user == null) {
            return Scaffold(
              appBar: TopBar(
                title: 'Profile',
                leftIcon: 'assets/svgs/back.svg',
                onLeftButtonTap: () => viewModel.leftButton(context),
                showRightButton: false,
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          } else {
            return Scaffold(
              appBar: TopBar(
                title: 'Profile',
                leftIcon: 'assets/svgs/back.svg',
                onLeftButtonTap: () => viewModel.leftButton(context),
                rightIcon: 'assets/svgs/logout.svg',
                onRightButtonTap: () => viewModel.rightButton(context),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and surname
                    Text(
                      '${viewModel.user?.name} ${viewModel.user?.surname}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Statistics card
                    Card(
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Statistics',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Amount of Plants: ${viewModel.statistics?.plantCount ?? 0}',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Settings card
                    Card(
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SwitchListTile(
                              title: const Text(
                                "Enable Notifications",
                                style: TextStyle(color: Colors.black),
                              ),
                              value: viewModel.notificationsEnabled,
                              onChanged: (bool value) {
                                viewModel.enableNotifications(value);
                              },
                              activeColor: Colors.black,
                              inactiveThumbColor: Colors.grey,
                              inactiveTrackColor: Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
