import 'package:flutter/material.dart';

class LeadersFooterSection extends StatelessWidget {
  const LeadersFooterSection({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
