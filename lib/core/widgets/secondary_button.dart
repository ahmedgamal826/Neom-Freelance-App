//t2 Core Packages Imports
import 'package:flutter/material.dart';

//t2 Dependancies Imports
//t3 Services
//t3 Models
//t1 Exports
class SecondaryButton extends StatelessWidget {
  //SECTION - Widget Arguments
  final String title;
  final Function onPressed;

  //!SECTION
  //
  const SecondaryButton({
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
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
          fontFamily: 'SF Pro Text',
          fontWeight: FontWeight.w500,
          letterSpacing: 0.16,
        ),
      ),
    );
    //!SECTION
  }
}
