import 'package:flutter/material.dart';
import 'package:neon/core/locale/app_localizations.dart';
import 'package:neon/core/locale/locale_provider.dart';
import 'package:neon/core/Services/Auth/auth_service.dart';
import 'package:neon/core/widgets/language_toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:neon/features/notifications/alarm%20code/utils/notification_helper.dart';
import '../pages/chat_page.dart';
import '../pages/home_page.dart';
import '../pages/images_page.dart';
import '../pages/neom_leaders_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const NeomLeadersPage(),
    const ImagesPage(),
    const ChatPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    // Schedule NEOM auto notifications only after the home screen opens.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // لا نحجب أول فريم
      // ignore: unawaited_futures
      NotificationHelper.ensureNeomDailyScheduled(
        daysAhead: 20,
        forceReschedule: true,
      );
    });
  }

  // _openAlarms لم تعد مستخدمة

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations(context.watch<LocaleProvider>().locale);
    final titles = <String>[
      l10n.navHome,
      l10n.navLeaders,
      l10n.navImages,
      l10n.navChat,
    ];
    return Scaffold(
        backgroundColor: const Color(0xff343538),
        appBar: AppBar(
          title: Text(
            titles[_selectedIndex],
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: <Widget>[
            LanguageToggleButton(iconColor: Colors.white),
            const SizedBox(width: 8),
          ],
          backgroundColor: const Color(0xff343538),
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: Text(l10n.navHome),
                        onTap: () => _onItemTapped(0),
                      ),
                      ListTile(
                        leading: const Icon(Icons.people),
                        title: Text(l10n.navLeaders),
                        onTap: () => _onItemTapped(1),
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: Text(l10n.navImages),
                        onTap: () => _onItemTapped(2),
                      ),
                      ListTile(
                        leading: const Icon(Icons.chat),
                        title: Text(l10n.navChat),
                        onTap: () => _onItemTapped(3),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(l10n.signOut),
                    onTap: () async {
                      Navigator.pop(context);
                      await AuthService().signOut(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _screens[_selectedIndex],
    );
  }
}
