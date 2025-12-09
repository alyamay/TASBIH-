import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/tasbih_model.dart';
import '../../utils/theme_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TasbihPage extends StatefulWidget {
  final Tasbih tasbih;
  const TasbihPage({super.key, required this.tasbih});

  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  late int count;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    count = widget.tasbih.count;

    _saveLastTasbih();
    _saveLocalCount();
  }

  Future<void> _saveLastTasbih() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('last_tasbih', widget.tasbih.nama);
  }

  Future<void> _saveLocalCount() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('tasbih_${widget.tasbih.nama}', count);
  }

  // 🔥 Save ke Firebase (Cloud Firestore)
  Future<void> _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => isSaving = true);

    try {
      final docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid);

      await docRef.set({
        "tasbihCounts": {widget.tasbih.nama: count},
      }, SetOptions(merge: true));
    } catch (e) {
      print("Gagal simpan Firebase: $e");
    }

    setState(() => isSaving = false);
  }

  void _increment() {
    setState(() => count++);
    _saveLocalCount();
    _saveToFirebase();
  }

  void _reset() {
    setState(() => count = 0);
    _saveLocalCount();
    _saveToFirebase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeManager.of(context).isDark.value;

    final bg = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF230E4E);
    final headerIcon = isDark ? Colors.white : Colors.black87;

    final screen = MediaQuery.of(context).size;
    final w = screen.width;
    final h = screen.height;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.06,
            vertical: h * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: headerIcon,
                    ),
                  ),
                  Text(
                    "TASBIH+",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF4FB7B3),
                      fontSize: w * 0.065,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),

              SizedBox(height: h * 0.05),

              // Judul Tasbih
              Text(
                widget.tasbih.nama,
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: w * 0.07,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: h * 0.1),

              // Circle Counter
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: w * 0.6,
                    height: w * 0.6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFA8FBD3), Color(0xFF4FB7B3)],
                      ),
                    ),
                  ),
                  Text(
                    "$count",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: w * 0.12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.1),

              // Tombol Tambah & Reset
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _increment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4FB7B3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      isSaving ? "..." : "Tambah",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _reset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF637AB9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      isSaving ? "..." : "Reset",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
