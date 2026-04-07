import 'package:flutter/material.dart';

class LightAndDarkModeButton extends StatelessWidget {
  const LightAndDarkModeButton({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  final bool isDarkMode;
  final void Function()? onToggleDarkMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: IconButton(
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            key: ValueKey(isDarkMode),
            color: isDarkMode ? Colors.white : Colors.black,
            size: 33,
          ),
        ),
        onPressed: onToggleDarkMode,
      ),
    );
  }
}
