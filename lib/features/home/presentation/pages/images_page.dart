//t2 Core Packages Imports
import 'package:flutter/material.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports

class ImagesPage extends StatelessWidget {
  // SECTION - Widget Arguments
  //!SECTION
  //
  const ImagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // SECTION - Build Setup
    // Values
    // double w = MediaQuery.of(context).size.width;",i
    // double h = MediaQuery.of(context).size.height;",
    // Widgets
    //
    // Widgets
    //!SECTION

    // SECTION - Build Return
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // The Image Grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 1,
                      mainAxisSpacing: 20,
                      children: [
                        _buildImageContainer(
                            'assets/images/neom_1.jpg', Colors.grey[800]!),
                        _buildImageContainer(
                            'assets/images/neom_5.jpg', Colors.grey[800]!),
                        _buildImageContainer(
                            'assets/images/neom_6.jpg', Colors.grey[800]!),
                        _buildImageContainer(
                            'assets/images/neom_7.jpg', Colors.grey[800]!),
                        _buildImageContainer(
                            'assets/images/neom_8.jpg', Colors.grey[800]!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create image containers
  Widget _buildImageContainer(String imageUrl, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
