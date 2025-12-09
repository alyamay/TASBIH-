import 'package:flutter/material.dart';
import 'package:project/utils/theme_manager.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChange;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    // LISTEN ke perubahan theme secara otomatis
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeManager.of(context).isDark,
      builder: (context, isDark, _) {
        return BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          selectedItemColor: isDark
              ? Colors.tealAccent
              : const Color(0xFF4FB7B3),
          unselectedItemColor: isDark ? Colors.white54 : Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: onChange,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              label: 'Doa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.circle_outlined),
              label: 'Tasbih',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              label: 'Fav',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        );
      },
    );
  }
}
