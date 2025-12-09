import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends InheritedWidget {
  final ValueNotifier<bool> isDark;

  ThemeManager({super.key, required Widget child, required this.isDark})
    : super(child: child);

  static ThemeManager of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<ThemeManager>();
    assert(result != null, 'No ThemeManager found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ThemeManager oldWidget) {
    return isDark.value != oldWidget.isDark.value;
  }

  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isDark") ?? false;
  }

  static Future<void> saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDark", value);
  }
}
