import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garden_app/repositories/auth_remote_repository.dart';
import 'package:garden_app/repositories/plant_remote_repository.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/widgets/top_bar.dart';
import '../viewmodels/home_viewmodel.dart';
import '../models/plant.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create:
          (_) => HomeViewModel(PlantRemoteRepository(), AuthRemoteRepository()),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: TopBar(),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 216, 216, 216),
                        blurRadius: 30,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: viewModel.searchQueryController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(10),
                      hintText: "Search for your plant...",
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 216, 216, 216),
                        fontSize: 14,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          'assets/svgs/magnifier.svg',
                          height: 15,
                        ),
                      ),
                      suffixIcon: SizedBox(
                        width: 60,
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const VerticalDivider(
                                color: Color.fromARGB(255, 216, 216, 216),
                                indent: 10,
                                endIndent: 10,
                                thickness: 0.5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                  'assets/svgs/filters.svg',
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: viewModel.updateSearchQuery,
                  ),
                ),
                const SizedBox(height: 20),
                // plants list
                Expanded(
                  child:
                      viewModel.plants.isEmpty
                          ? const Center(child: Text("No plants found."))
                          : ListView.builder(
                            itemCount: viewModel.plants.length,
                            itemBuilder: (context, index) {
                              final Plant plant = viewModel.plants[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromARGB(
                                          255,
                                          216,
                                          216,
                                          216,
                                        ),
                                        blurRadius: 30,
                                        spreadRadius: 0.0,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // main button
                                      Expanded(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(15),
                                            alignment: Alignment.centerLeft,
                                          ),
                                          onPressed: () {
                                            // TODO
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
                                      // watter button
                                      IconButton(
                                        onPressed: () {
                                          // TODO
                                          viewModel.water(plant);
                                        },
                                        icon: const Icon(Icons.water_drop),
                                        color:
                                            plant.needWater
                                                ? Colors.blueAccent
                                                : Colors.black,
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
