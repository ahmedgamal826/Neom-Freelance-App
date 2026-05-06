//t2 Core Packages Imports
import 'package:flutter/material.dart';

//t2 Dependancies Imports
//t3 Services
//t3 Models
//t1 Exports
class TertiaryButton extends StatelessWidget {
  //SECTION - Widget Arguments
  final String title;
  final Function onPressed;

  //!SECTION
  //
  const TertiaryButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    //SECTION - Build Setup
    //t2 -Values
    //double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    //t2 -Values
    //
    //t2 -Widgets
    //t2 -Widgets
    //!SECTION

    //SECTION - Build Return
    return TextButton(
      onPressed: () => onPressed(),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFFAAD49),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.16,
        ),
      ),
    );
    //!SECTION
  }
}
