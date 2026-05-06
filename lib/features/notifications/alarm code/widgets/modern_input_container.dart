import 'package:flutter/material.dart';

class ModernInputCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final bool isDarkMode;

  const ModernInputCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.30 : 0.20),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.blue.withOpacity(0.18)
                  : const Color(0xFF2196F3).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: isDarkMode ? Colors.blue[200] : const Color(0xFF2196F3),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                  title,
                      textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                  ),
                ),
                const SizedBox(height: 8),
                child,
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
