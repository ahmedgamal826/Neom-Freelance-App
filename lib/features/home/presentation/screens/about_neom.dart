//t2 Core Packages Imports
import 'package:flutter/material.dart';

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
    // SECTION - Build Setup
    // Values
    // double w = MediaQuery.of(context).size.width;",
    // double h = MediaQuery.of(context).size.height;",
    // Widgets
    //
    // Widgets
    //!SECTION

    // SECTION - Build Return
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "عن نيوم",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff343538),
          iconTheme: const IconThemeData(
              color: Colors.white), // Set leading icon color to white
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Hero header
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
                    children: const <Widget>[
                      Text(
                        "عن نيوم",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "رؤية طموحة لبناء مدن المستقبل بالابتكار والاستدامة",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ],
                  ),
                ),

                // About paragraph in a card
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
                          const Text(
                            "ما هي نيوم؟",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "نيوم مشروع عملاق ورؤيوي أطلقته المملكة العربية السعودية كجزء من مبادرة رؤية 2030؛ "
                            "يهدف إلى إنشاء بيئة حضرية ذكية مستدامة تعتمد على أحدث التقنيات وتوفر جودة حياة استثنائية.",
                            style: TextStyle(height: 1.6),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const <Widget>[
                              _TagChip(icon: Icons.trending_up, label: "النمو الاقتصادي", color: Color(0xFF43A047)),
                              _TagChip(icon: Icons.psychology_alt_outlined, label: "الابتكار", color: Color(0xFFE53935)),
                              _TagChip(icon: Icons.explore_outlined, label: "الموقع الاستراتيجي", color: Color(0xFFFFA000)),
                              _TagChip(icon: Icons.eco_outlined, label: "الاستدامة", color: Color(0xFF2E7D32)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Why NEOM section on dark background
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 22),
                  color: const Color(0xff343538),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "لماذا نيوم؟",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _WhyTile(
                        title: '"NEO"',
                        subtitle: 'كلمة يونانية تعني "جديد"',
                        leadingIcon: Icons.fiber_new,
                      ),
                      const SizedBox(height: 8),
                      _WhyTile(
                        title: '"M"',
                        subtitle: 'ترمز إلى "مستقبل"',
                        leadingIcon: Icons.auto_awesome,
                      ),
                    ],
                  ),
                ),

                // Visual brand image
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
  const _TagChip({required this.icon, required this.label, required this.color});

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
