import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/doa_model.dart';
import '../../utils/bookmark_manager.dart';

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  Doa? doa;
  bool isSaved = false;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _loadDoaData();
      _isLoaded = true;
    }
  }

  Future<void> _loadDoaData() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final judul = args?['judul'];
    print("DEBUG: judul dari arguments = $judul");

    if (judul == null) {
      print("Tidak ada judul dikirim ke DoaPage");
      return;
    }

    final dataString = await rootBundle.loadString('lib/data/dummy_data.json');
    final data = json.decode(dataString);

    final List<dynamic> listDoa = data['doa'] ?? [];
    final doaItem = listDoa.firstWhere(
      (e) => e['judul'] == judul,
      orElse: () => null,
    );

    if (doaItem != null) {
      setState(() {
        doa = Doa(
          judul: doaItem['judul'],
          arab: doaItem['arab'],
          latin: doaItem['latin'],
          arti: doaItem['arti'],
        );
        isSaved = BookmarkManager.isBookmarked(doa!);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_read', doa!.judul);
    } else {
      print("DEBUG: Doa tidak ditemukan untuk judul $judul");
    }
  }

  void toggleBookmark() {
    if (doa == null) return;
    setState(() {
      BookmarkManager.toggleBookmark(doa!);
      isSaved = !isSaved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSaved ? 'Ditambahkan ke bookmark' : 'Dihapus dari bookmark',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: doa == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.06,
                  vertical: h * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          "TASBIH+",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF4FB7B3),
                            fontSize: w * 0.065,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isSaved
                                ? Icons.bookmark
                                : Icons.bookmark_border_rounded,
                            color: const Color(0xFF4FB7B3),
                          ),
                          onPressed: toggleBookmark,
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.03),

                    // 🔹 Card Utama (judul doa)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: h * 0.04,
                        horizontal: w * 0.08,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFADEED9), Color(0xFF0ABAB5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            doa!.judul,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: w * 0.07,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.04),

                    // 🔹 Isi doa
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0x0C121931),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            doa!.arab,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.amiri(
                              color: const Color(0xFF230E4E),
                              fontSize: w * 0.065,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: h * 0.015),
                          Text(
                            doa!.latin,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF4FB7B3),
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: h * 0.015),
                          Text(
                            doa!.arti,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF230E4E),
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
