//t2 Core Packages Imports
import 'package:flutter/material.dart';

import '../screens/about_neom.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports

class HomePage extends StatelessWidget {
  // SECTION - Widget Arguments
  //!SECTION
  //
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // SECTION - Build Setup
    // Values
    // double w = MediaQuery.of(context).size.width;",
    // double h = MediaQuery.of(context).size.height;",
    // Widgets
    //
    // Widgets
    //!SECTION

    // SECTION - Build Return
    return Scaffold(
      backgroundColor: const Color(0xff343538),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/saudi_arabia_map.jpg",
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: const Color(0xff343538),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (states) => Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const AboutNeom(),
                      ),
                    );
                  },
                  child: const Text(
                    "عن نيوم",
                    style: TextStyle(color: Colors.black),
                  )),
            ),
            Image.asset(
              "assets/images/timeline.jpg",
            ),
          ],
        ),
      ),
    );

    //!SECTION
  }
}
