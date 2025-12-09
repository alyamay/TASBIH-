import 'package:flutter/material.dart';
import 'package:project/models/tasbih_model.dart';
import 'package:project/pages/bookmark_list_page.dart';
import 'package:project/pages/splash_screen.dart';
import 'package:project/pages/login_page.dart';
import 'package:project/pages/register_page.dart';
import 'package:project/pages/home_page.dart';
import 'package:project/pages/tasbih_page.dart';
import 'package:project/pages/favorite_page.dart';
import 'package:project/pages/settings_page.dart';
import 'package:project/pages/doa_page.dart';
import 'package:project/pages/tasbih_list_page.dart';
import 'package:project/pages/doa_list_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const LoginPage());

    case '/splash':
      return MaterialPageRoute(builder: (_) => const SplashScreen());

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

    case '/bookmark':
      return MaterialPageRoute(builder: (_) => const FavoritePage());

    case '/bookmark-list':
      return MaterialPageRoute(
        builder: (_) => const BookmarkListPage(),
        settings: settings,
      );

    case '/tasbih':
      final tasbih = settings.arguments as Tasbih;
      return MaterialPageRoute(builder: (_) => TasbihPage(tasbih: tasbih));

    case '/doa':
      return MaterialPageRoute(
        builder: (_) => const DoaPage(),
        settings: settings,
      );

    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text("Route tidak ditemukan: ${settings.name}")),
        ),
      );
  }
}
