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

  /// Builds a dynamic timeline similar to the static image but generated
  /// programmatically so new years appear automatically.
  Widget _buildTimelineImage() {
    final int startYear = 2017;
    final int currentYear = DateTime.now().year;
    final List<int> years =
        List<int>.generate(currentYear - startYear + 1, (int i) => startYear + i)
            .reversed
            .toList(); // newest at the left like the screenshot

    const Color backgroundTop = Color(0xFF2F3033);
    const Color backgroundBottom = Color(0xFF1C1D1F);
    const Color titleColor = Colors.white;
    const Color yearColor = Colors.white70;
    const Color highlightColor = Color(0xfff5d74f);
    const Color dotsInactive = Colors.white30;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[backgroundTop, backgroundBottom],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            "OUR JOURNEY",
            style: TextStyle(
              color: titleColor,
              fontSize: 22,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 70,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              reverse: true, // years already reversed; keep UX consistent
              itemBuilder: (BuildContext context, int index) {
                final int year = years[index];
                final bool isCurrent = year == currentYear;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: isCurrent
                          ? BoxDecoration(
                              color: const Color(0xff171B22),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                  color: Color(0x66f5d74f),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            )
                          : null,
                      child: Text(
                        "$year",
                        style: TextStyle(
                          color: isCurrent ? highlightColor : yearColor,
                          fontSize: isCurrent ? 20 : 16,
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isCurrent ? highlightColor : dotsInactive,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 18),
              itemCount: years.length,
            ),
          ),
        ],
      ),
    );
  }
}
