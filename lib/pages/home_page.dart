// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:project/pages/doa_list_page.dart';
import 'package:project/pages/favorite_page.dart';
import 'package:project/pages/settings_page.dart';
import 'package:project/pages/tasbih_list_page.dart';
import '../../widgets/bottom_nav.dart';
import 'package:project/pages/home_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final pages = const [
    HomeContent(),      
    DoaListPage(),
    TasbihListPage(),
    FavoritePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],  
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onChange: (index) {
          setState(() => currentIndex = index);
        },
      ),
    );
  }
}
