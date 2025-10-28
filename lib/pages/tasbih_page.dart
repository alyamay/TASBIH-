import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/tasbih_model.dart';

class TasbihPage extends StatefulWidget {
  final Tasbih tasbih;
  const TasbihPage({super.key, required this.tasbih});

  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.tasbih.count;
    _saveCount();
    _saveLastTasbih();
  }

  Future<void> _saveCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbih_${widget.tasbih.nama}', count);
  }

  Future<void> _saveLastTasbih() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_tasbih', widget.tasbih.nama);
  }

  void _increment() {
    setState(() {
      count++;
    });
    _saveCount();
  }

  void _reset() {
    setState(() {
      count = 0;
    });
    _saveCount();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final w = screen.width;
    final h = screen.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.06,
            vertical: h * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Tasbih+",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF4FB7B3),
                      fontSize: w * 0.065,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 30), // biar center
                ],
              ),

              SizedBox(height: h * 0.05),

              // 🔹 Nama Tasbih
              Text(
                widget.tasbih.nama,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF230E4E),
                  fontSize: w * 0.07,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: h * 0.04),

              // 🔹 Circle Counter mirip di HomePage
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: w * 0.6,
                    height: w * 0.6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
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

              SizedBox(height: h * 0.06),

              // 🔹 Tombol Tambah & Reset
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
                      "Tambah",
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
                      "Reset",
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
