import 'package:flutter/material.dart';

class ChatStatusMessagePanel extends StatelessWidget {
  const ChatStatusMessagePanel({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2D31),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white70, height: 1.45),
        textAlign: TextAlign.center,
      ),
    );
  }
}
