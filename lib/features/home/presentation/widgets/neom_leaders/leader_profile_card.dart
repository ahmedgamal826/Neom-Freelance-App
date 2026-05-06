import 'package:flutter/material.dart';

import 'neom_leader_entry.dart';

class LeaderProfileCard extends StatelessWidget {
  const LeaderProfileCard({
    super.key,
    required this.entry,
    required this.isArabic,
  });

  final NeomLeaderEntry entry;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            entry.image,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10),
          Text(
            entry.name(isArabic),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            entry.title(isArabic),
            style: TextStyle(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
