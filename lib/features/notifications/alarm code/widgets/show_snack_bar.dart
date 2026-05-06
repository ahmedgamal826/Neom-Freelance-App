import 'package:flutter/material.dart';

void customShowSnackBar({
  required BuildContext context,
  required String content,
  Color? backgroundColor,
}) {
  final isError = backgroundColor != null &&
      backgroundColor.red > 200 &&
      backgroundColor.green < 100;
  final icon = isError ? Icons.error_outline : Icons.info_outline;
  final iconColor = Colors.white;
  final snackBarColor = backgroundColor ??
      (isError ? const Color(0xFFE53935) : const Color(0xFF2196F3));

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
      backgroundColor: snackBarColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      elevation: 8,
    ),
  );
}
