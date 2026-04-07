import 'package:flutter/material.dart';

class AnimationTitle extends StatelessWidget {
  const AnimationTitle({
    super.key,
    required Animation<double> fadeController,
    required Animation<double> slideController,
    required this.animationTitle,
    required this.isDarkMode,
  })  : _fadeController = fadeController,
        _slideController = slideController;

  final Animation<double> _fadeController;
  final Animation<double> _slideController;
  final bool isDarkMode;
  final String animationTitle;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _slideController,
          curve: Curves.easeOutCubic,
        )),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    animationTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
