import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garden_app/repositories/auth_remote_repository.dart';
import 'package:garden_app/repositories/plant_remote_repository.dart';
import 'package:provider/provider.dart';
import 'package:garden_app/widgets/top_bar.dart';
import '../viewmodels/home_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel(PlantRemoteRepository(), AuthRemoteRepositary()),
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
                      )
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
                    // Update ViewModel when text changes.
                    onChanged: viewModel.updateSearchQuery,
                  ),
                ),
                // Here you could add additional widgets that use viewModel.searchQuery,
                // for example, to display filtered search results.
              ],
            ),
          );
        },
      ),
    );
  }
}
