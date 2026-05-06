//t2 Core Packages Imports
import 'package:flutter/material.dart';
import 'package:neon/core/locale/app_localizations.dart';
import 'package:neon/core/locale/locale_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/neom_leaders/leaders_accent_bar.dart';
import '../widgets/neom_leaders/leaders_footer_section.dart';
import '../widgets/neom_leaders/leaders_people_grid.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports

class NeomLeadersPage extends StatelessWidget {
  // SECTION - Widget Arguments
  //!SECTION
  //
  const NeomLeadersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations(context.watch<LocaleProvider>().locale);

    // SECTION - Build Return
    return Scaffold(
      body: Column(
        children: [
          const LeadersAccentBar(color: Color(0xffEC796C)),
          const Flexible(child: LeadersPeopleGrid()),
          const LeadersAccentBar(color: Color(0xff606060)),
          LeadersFooterSection(text: l10n.leadersPageFooter),
        ],
      ),
    );

    //!SECTION
  }
}
