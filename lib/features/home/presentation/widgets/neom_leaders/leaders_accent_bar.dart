import 'package:flutter/material.dart';

/// Thin full-width strip used above/below the leaders grid.
class LeadersAccentBar extends StatelessWidget {
  const LeadersAccentBar({
    super.key,
    required this.color,
    this.height = 30,
  });

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: color,
    );
  }
}
