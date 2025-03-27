import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              title: 'Home',
              leftIcon: 'assets/svgs/profile.svg',
              onLeftButtonTap: () => viewModel.leftButton(context),
              rightIcon: 'assets/svgs/plus.svg',
              onRightButtonTap: () => viewModel.rightButton(context),
            ),
            body: Column(
              children: [
                // Search field
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: TextField(
                    controller: viewModel.searchQueryController,
                    decoration: InputDecoration(
                      hintText: "Search for your plant...",
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
                      suffixIcon: SizedBox(
                        width: 60,
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const VerticalDivider(
                                color: Colors.black,
                                indent: 10,
                                endIndent: 10,
                                thickness: 2,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                  'assets/svgs/filters.svg',
                                  height: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
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
                // Plants list
                Expanded(
                  child:
                      viewModel.plants.isEmpty
                          ? const Center(
                            child: Text(
                              "No plants found.",
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                          : ListView.builder(
                            itemCount: viewModel.plants.length,
                            itemBuilder: (context, index) {
                              final Plant plant = viewModel.plants[index];
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
                                      // Main button for plant name
                                      Expanded(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(15),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          onPressed: () {
                                            // TODO: Implement action (e.g., show plant details)
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
                                      // Water button
                                      IconButton(
                                        onPressed: () {
                                          viewModel.water(plant);
                                        },
                                        icon: const Icon(Icons.water_drop),
                                        color:
                                            plant.needWater
                                                ? Colors.black
                                                : Colors.black,
                                        // Alternatively, if you want a distinct color when watering:
                                        // color: plant.needWater ? Colors.blue : Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
