import 'package:flutter/material.dart';
import 'package:project/models/tasbih_model.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/tasbih_page.dart';
import 'pages/favorite_page.dart';
import 'pages/settings_page.dart';
import 'pages/doa_page.dart';
import 'pages/tasbih_list_page.dart';
import 'pages/doa_list_page.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/login':
      return MaterialPageRoute(builder: (_) => const LoginPage());
    case '/register':
      return MaterialPageRoute(builder: (_) => const RegisterPage());
    case '/home':
      return MaterialPageRoute(builder: (_) => const HomePage());
    case '/favorite':
      return MaterialPageRoute(builder: (_) => const FavoritePage());
    case '/settings':
      return MaterialPageRoute(builder: (_) => const SettingsPage());
    case '/doa-list':
      return MaterialPageRoute(builder: (_) => const DoaListPage());
    case '/tasbih-list':
      return MaterialPageRoute(builder: (_) => const TasbihListPage());
    case '/tasbih':
      final tasbih = settings.arguments as Tasbih;
      return MaterialPageRoute(builder: (_) => TasbihPage(tasbih: tasbih));
    case '/doa':
      final args = settings.arguments as Map?;
      final judul = args?['judul'] as String?;
      print("Route menerima judul: $judul");
      return MaterialPageRoute(
        builder: (_) =>
            DoaPage(), // DoaPage tetap seperti yang kamu kirim terakhir
        settings: RouteSettings(arguments: {'judul': judul}),
      );
    default:
      return MaterialPageRoute(builder: (_) => const HomePage());
  }
}
