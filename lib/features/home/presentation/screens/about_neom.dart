//t2 Core Packages Imports
import 'package:flutter/material.dart';
import 'package:neon/core/locale/app_localizations.dart';
import 'package:neon/core/locale/locale_provider.dart';
import 'package:provider/provider.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports

class AboutNeom extends StatelessWidget {
  // SECTION - Widget Arguments
  //!SECTION
  //
  const AboutNeom({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations(context.watch<LocaleProvider>().locale);

    // SECTION - Build Return
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.aboutNeomTitle,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff343538),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xFF202124), Color(0xFF343538)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    l10n.aboutNeomTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.aboutNeomHeroSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, height: 1.5),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.aboutWhatIsNeom,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.aboutWhatIsNeomBody,
                        style: const TextStyle(height: 1.6),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          _TagChip(
                            icon: Icons.trending_up,
                            label: l10n.tagEconomicGrowth,
                            color: const Color(0xFF43A047),
                          ),
                          _TagChip(
                            icon: Icons.psychology_alt_outlined,
                            label: l10n.tagInnovation,
                            color: const Color(0xFFE53935),
                          ),
                          _TagChip(
                            icon: Icons.explore_outlined,
                            label: l10n.tagStrategicLocation,
                            color: const Color(0xFFFFA000),
                          ),
                          _TagChip(
                            icon: Icons.eco_outlined,
                            label: l10n.tagSustainability,
                            color: const Color(0xFF2E7D32),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 22),
              color: const Color(0xff343538),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    l10n.aboutWhyNeom,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _WhyTile(
                    title: '"NEO"',
                    subtitle: l10n.aboutNeoMeaning,
                    leadingIcon: Icons.fiber_new,
                  ),
                  const SizedBox(height: 8),
                  _WhyTile(
                    title: '"M"',
                    subtitle: l10n.aboutMMeaning,
                    leadingIcon: Icons.auto_awesome,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/app_logo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    //!SECTION
  }
}

class _TagChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _TagChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

class _WhyTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData leadingIcon;
  const _WhyTile({
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x3328282C)),
      ),
      child: Row(
        children: <Widget>[
          Icon(leadingIcon, color: const Color(0xFFF5D74F)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
