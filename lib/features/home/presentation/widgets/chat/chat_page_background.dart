import 'package:flutter/material.dart';

class ChatPageBackground extends StatelessWidget {
  const ChatPageBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF202124), Color(0xFF343538), Color(0xFF1C1D1F)],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
