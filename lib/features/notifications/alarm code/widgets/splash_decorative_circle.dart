import 'package:flutter/material.dart';

class SplashDecorativeCircle extends StatelessWidget {
  final double size;
  final bool isDarkMode;
  const SplashDecorativeCircle(
      {Key? key, required this.size, required this.isDarkMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60 * size,
      height: 60 * size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.2),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
