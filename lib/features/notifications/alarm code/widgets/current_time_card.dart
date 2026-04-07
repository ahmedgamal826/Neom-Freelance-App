import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentTimeCard extends StatelessWidget {
  const CurrentTimeCard({
    super.key,
    required this.screenHeight,
  });

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2196F3).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time,
            color: Color(0xFF2196F3),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Current time:  ' +
                DateFormat('hh:mm:ss a')
                    .format(DateTime.now()), // 12 ساعة مع AM/PM
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2196F3),
            ),
          ),
        ],
      ),
    );
  }
}
