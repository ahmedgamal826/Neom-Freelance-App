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
            _buildTimelineImage(),
          ],
        ),
      ),
    );

    //!SECTION
  }

  Widget _buildTimelineImage() {
    return Stack(
      children: [
        Image.asset("assets/images/timelineNew.png"),
        // Overlay the first year label to show the updated value without
        // needing to regenerate the static timeline image asset.
        // Positioned(
        //   left: 10,
        //   bottom: 70,
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        //     color: const Color(0xff171B22),
        //     child: const Text(
        //       "2026",
        //       style: TextStyle(
        //         color: Color(0xfff5d74f),
        //         fontSize: 56,
        //         fontWeight: FontWeight.w700,
        //         height: 0.95,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
