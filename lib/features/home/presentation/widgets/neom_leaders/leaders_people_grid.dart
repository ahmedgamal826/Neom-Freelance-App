import 'package:flutter/material.dart';
import 'package:neon/core/locale/locale_provider.dart';
import 'package:provider/provider.dart';

import 'leader_profile_card.dart';
import 'neom_leader_entry.dart';

class LeadersPeopleGrid extends StatelessWidget {
  const LeadersPeopleGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic =
        context.watch<LocaleProvider>().locale.languageCode == 'ar';
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width >= 1200
        ? 4
        : width >= 900
            ? 3
            : 2;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: kNeomLeaders.length,
      itemBuilder: (context, index) {
        return LeaderProfileCard(
          entry: kNeomLeaders[index],
          isArabic: isArabic,
        );
      },
    );
  }
}
