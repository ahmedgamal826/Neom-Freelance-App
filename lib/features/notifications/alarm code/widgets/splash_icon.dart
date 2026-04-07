import 'package:flutter/material.dart';

class SplashIcon extends StatelessWidget {
  final bool isDarkMode;
  const SplashIcon({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Blue glow/halo
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isDarkMode
                    ? [
                        const Color(0xFF2196F3).withOpacity(0.35),
                        Colors.transparent
                      ]
                    : [
                        const Color(0xFF2196F3).withOpacity(0.18),
                        Colors.transparent
                      ],
                stops: const [0.7, 1.0],
              ),
            ),
          ),
          // The icon itself
          ClipOval(
            child: Container(
              width: 110,
              height: 110,
              color: Colors.transparent,
              child: Image.asset(
                'assets/alarm_splash_icon-removebg-preview.png',
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
