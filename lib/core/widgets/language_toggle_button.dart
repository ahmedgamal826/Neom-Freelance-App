import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../locale/locale_provider.dart';

/// Toggles app locale between Arabic and English (persists via [LocaleProvider]).
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key, this.iconColor});

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocaleProvider>();
    final isAr = provider.locale.languageCode == 'ar';
    return IconButton(
      icon: Icon(Icons.language, color: iconColor),
      tooltip: isAr ? 'English' : 'العربية',
      onPressed: () => provider.toggleLocale(),
    );
  }
}
