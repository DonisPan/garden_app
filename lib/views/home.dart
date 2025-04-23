import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garden_app/views/plant_detail.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/models/plant.dart';
import 'package:garden_app/repositories/auth_repository.dart';
import 'package:garden_app/repositories/plant_repository.dart';
import 'package:garden_app/viewmodels/home_viewmodel.dart';
import 'package:garden_app/widgets/top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create:
          (_) => HomeViewModel(
            plantRepository: Provider.of<PlantRepository>(
              context,
              listen: false,
            ),
            authRepository: Provider.of<AuthRepository>(context, listen: false),
          ),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: TopBar(
              title: 'home.title'.tr(),
              leftIcon: 'assets/svgs/profile.svg',
              onLeftButtonTap: () => viewModel.leftButton(context),
              rightIcon: 'assets/svgs/plus.svg',
              onRightButtonTap: () => viewModel.rightButton(context),
            ),
            body: Column(
              children: [
                // search
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: TextField(
                    controller: viewModel.searchQueryController,
                    decoration: InputDecoration(
                      hintText: 'home.search_hint'.tr(),
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          'assets/svgs/magnifier.svg',
                          height: 15,
                          color: Colors.black,
                        ),
                      ),
                      suffixIcon: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // notifications button with badge
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/svgs/bell.svg',
                                    height: 20,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    viewModel.openSpecialAnnouncers(context);
                                  }, // no-op for now
                                ),
                                if (viewModel.specialAnnouncers.isNotEmpty)
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        '${viewModel.specialAnnouncers.length}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: viewModel.updateSearchQuery,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                // plants list
                Expanded(
                  child:
                      viewModel.filteredPlants.isEmpty
                          ? Center(
                            child: Text(
                              'home.no_plants_found'.tr(),
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                          : RefreshIndicator(
                            onRefresh: () async {
                              await viewModel.fetchPlants();
                            },
                            child: ListView.builder(
                              itemCount: viewModel.filteredPlants.length,
                              itemBuilder: (context, index) {
                                final Plant plant =
                                    viewModel.filteredPlants[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 8,
                                          spreadRadius: 0,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        // plant button
                                        Expanded(
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.all(15),
                                              alignment: Alignment.centerLeft,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          PlantDetailPage(
                                                            plant: plant,
                                                          ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              plant.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
