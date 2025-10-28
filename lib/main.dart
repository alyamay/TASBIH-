import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/bookmark_manager.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <— penting!
  await BookmarkManager.loadBookmarks();
  runApp(const TasbihPlusApp());
}

class TasbihPlusApp extends StatelessWidget {
  const TasbihPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasbih+',
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: const SplashScreen(),
      onGenerateRoute: generateRoute, 
    );
  }
}
