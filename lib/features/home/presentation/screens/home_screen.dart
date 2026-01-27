//t2 Core Packages Imports
import 'package:flutter/material.dart';
import 'package:neon/core/Services/Auth/auth_service.dart';

import '../pages/chat_page.dart';
import '../pages/home_page.dart';
import '../pages/images_page.dart';
import '../pages/neom_leaders_page.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports

class HomeScreen extends StatefulWidget {
  // SECTION - Widget Arguments
  //!SECTION
  //
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<String> _titles = [
    "الرئيسية",
    "قادة نيوم",
    "الصور",
    "شاشة الدردشة"
  ];

  final List<Widget> _screens = [
    const HomePage(),
    const NeomLeadersPage(),
    const ImagesPage(),
    const ChatPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context);
    });
  }

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
        backgroundColor: const Color(0xff343538),
        appBar: AppBar(
          title: Text(
            _titles[_selectedIndex],
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
                      // Main Overview Section
                      ListTile(
                        leading: const Icon(Icons.home),
                        title: const Text('الرئيسية'),
                        onTap: () => _onItemTapped(0),
                      ),
                      ListTile(
                        leading: const Icon(Icons.people),
                        title: const Text('قادة نيوم'),
                        onTap: () => _onItemTapped(1),
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('الصور'),
                        onTap: () => _onItemTapped(2),
                      ),
                      ListTile(
                        leading: const Icon(Icons.chat),
                        title: const Text('شاشة الدردشة'),
                        onTap: () => _onItemTapped(3),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('تسجيل الخروج'),
                    onTap: () {
                      AuthService().signOut(context);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _screens[_selectedIndex],
      ),
    );
  }
//!SECTION
}
