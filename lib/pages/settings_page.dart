import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/theme_manager.dart';
import 'change_name_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String userName = "User";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString("username") ?? "User";
    });
  }

  void _toggleTheme(BuildContext context) {
    final theme = ThemeManager.of(context).isDark;
    final newValue = !theme.value;

    theme.value = newValue;
    ThemeManager.saveTheme(newValue);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newValue ? "Dark Mode Activated" : "Light Mode Activated",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return ValueListenableBuilder<bool>(
      valueListenable: ThemeManager.of(context).isDark,
      builder: (_, isDark, __) {
        final bg = isDark ? const Color(0xFF121212) : Colors.white;
        final textColor = isDark ? Colors.white : const Color(0xFF230E4E);

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.07),
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    // FIXED PROFILE AVATAR WITH ICON ONLY
                    CircleAvatar(
                      radius: 85,
                      backgroundColor: const Color(0xFF4FB7B3).withOpacity(0.3),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(
                          Icons.person,
                          size: 85,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Text(
                      userName,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // CHANGE NAME (MASIH ADA)
                    _menuButton("Change Name", isDark, () async {
                      final newName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangeNamePage(),
                        ),
                      );

                      if (newName != null) {
                        setState(() => userName = newName);
                      }
                    }),

                    const SizedBox(height: 20),

                    // THEME SWITCH
                    _menuButton(
                      isDark ? "Switch to Light Mode" : "Switch to Dark Mode",
                      isDark,
                      () => _toggleTheme(context),
                    ),

                    const SizedBox(height: 50),

                    // LOGOUT BUTTON
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        final prefs = await SharedPreferences.getInstance();

                        prefs.remove("username");
                        prefs.remove("photoUrl");

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.redAccent,
                            width: 1.8,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Log Out",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _menuButton(String title, bool dark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF1E1E1E) : const Color(0xFFF4F7FA),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4FB7B3),
            ),
          ),
        ),
      ),
    );
  }
}
