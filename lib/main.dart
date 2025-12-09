import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/theme_manager.dart';
import 'routes.dart';
import 'utils/collection_manager.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Init Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Init Theme
  final initialDark = await ThemeManager.loadTheme();
  final themeNotifier = ValueNotifier<bool>(initialDark);

  /// Init Default Collections (tasbih data)
  await CollectionManager.ensureDefaultCollection();

  runApp(
    ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (_, isDark, __) {
        return ThemeManager(
          isDark: themeNotifier,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Tasbih+",
            theme: ThemeData(
              brightness: isDark ? Brightness.dark : Brightness.light,
              textTheme: GoogleFonts.poppinsTextTheme(),
              scaffoldBackgroundColor: isDark
                  ? const Color(0xFF121212)
                  : Colors.white,
            ),
            home: const SplashScreen(),
            onGenerateRoute: generateRoute,
          ),
        );
      },
    ),
  );
}
