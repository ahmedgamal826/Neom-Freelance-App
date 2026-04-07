import 'package:flutter/material.dart';

class SplashTitle extends StatelessWidget {
  final bool isDarkMode;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<double> textFadeAnimation;
  const SplashTitle(
      {Key? key,
      required this.isDarkMode,
      required this.fadeAnimation,
      required this.slideAnimation,
      required this.textFadeAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: textFadeAnimation,
        child: Column(
          children: [
            Text(
              'Alarm App',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.white,
                letterSpacing: 3,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.4),
                    offset: const Offset(0, 3),
                    blurRadius: 6,
                  ),
                  Shadow(
                    color: isDarkMode
                        ? const Color(0xFF2196F3).withOpacity(0.3)
                        : Colors.white.withOpacity(0.3),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Wake up with style',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode
                    ? Colors.white.withOpacity(0.9)
                    : Colors.white.withOpacity(0.95),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),
            // Loading indicator
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDarkMode
                      ? const Color(0xFF2196F3)
                      : Colors.white.withOpacity(0.8),
                ),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
