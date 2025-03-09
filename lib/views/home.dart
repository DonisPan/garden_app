import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garden_app/widgets/top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 5, left: 5, right: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 216, 216, 216),
                  blurRadius: 30,
                  spreadRadius: 0.0
                )
              ]
            ),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(10),
                hintText: "Search for your plant...",
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 216, 216, 216),
                  fontSize: 14,
                ),

                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset('assets/svgs/magnifier.svg', height: 15,),
                ),

                suffixIcon: SizedBox(
                  width: 60,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        VerticalDivider(
                          color: Color.fromARGB(255, 216, 216, 216),
                          indent: 10,
                          endIndent: 10,
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset('assets/svgs/filters.svg', height: 20,),                  
                        ),
                      ],
                    ),
                  ),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}