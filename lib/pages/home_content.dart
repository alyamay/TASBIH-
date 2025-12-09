import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/models/tasbih_model.dart';
import 'dart:async';
import 'package:project/utils/theme_manager.dart';
import 'package:project/models/quote_model.dart';
import 'package:project/services/quote_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String? lastReadTitle;
  String? lastTasbih;
  int? lastTasbihCount;
  int? lastReadId;

  List<Quote> allQuotes = [];
  Quote? currentQuote;
  bool isLoadingQuote = true;

  String userName = "";

  @override
  void initState() {
    super.initState();
    _loadLastRead();
    _loadLastTasbih();
    loadQuotes();
    _loadUserName();
  }

  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastReadTitle = prefs.getString('last_read_judul');
      lastReadId = prefs.getInt('last_read_id');
    });
    print("LAST READ = $lastReadTitle");
  }

  Future<void> _loadLastTasbih() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastTasbih = prefs.getString('last_tasbih');
      lastTasbihCount = prefs.getInt('tasbih_${lastTasbih ?? ''}') ?? 0;
    });
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();

    final localName = prefs.getString("username");
    if (localName != null && localName.isNotEmpty) {
      setState(() => userName = localName);
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (!doc.exists) return;

      final data = doc.data();
      if (data == null) return;

      final onlineName = data["name"];
      if (onlineName != null && onlineName.isNotEmpty) {
        setState(() => userName = onlineName);
        prefs.setString("username", onlineName);
      }
    } catch (e) {
      print("Firestore read failed: $e");
    }
  }

  Future<void> loadQuotes() async {
    try {
      allQuotes = await QuoteService.fetchAllQuotes();
      _pickRandomQuote();
    } catch (e) {
      print("Error loading quotes: $e");
    }
  }

  void _pickRandomQuote() {
    if (allQuotes.isEmpty) return;

    allQuotes.shuffle();
    setState(() {
      currentQuote = allQuotes.first;
      isLoadingQuote = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final isDark = ThemeManager.of(context).isDark.value;

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: screen.width * 0.06,
        vertical: 30,
      ),
      children: [
        // HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TASBIH+",
                  style: GoogleFonts.poppins(
                    color: isDark ? Colors.tealAccent : Color(0xFF4FB7B3),
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Assalamualaikum,",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF637AB9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  userName.isEmpty ? "Loading..." : userName,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF230E4E),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 25),

        // LAST READ
        GestureDetector(
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();
            final id = prefs.getInt('last_read_id');

            if (id != null) {
              Navigator.pushNamed(context, '/doa', arguments: {'id': id});
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Belum ada doa yang dibaca")),
              );
            }
          },

          child: Container(
            width: double.infinity,
            height: screen.height * 0.18,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF637AB9), Color(0xFF31326F)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 3,
                  top: 23,
                  child: Image.asset('assets/images/depan.png', width: 170),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Last Read",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        lastReadTitle ?? "Belum ada doa dibaca",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // LAST TASBIH
        GestureDetector(
          onTap: () {
            if (lastTasbih != null && lastTasbih!.isNotEmpty) {
              Navigator.pushNamed(
                context,
                '/tasbih',
                arguments: Tasbih(
                  nama: lastTasbih!,
                  count: lastTasbihCount ?? 0,
                ),
              ).then((_) => _loadLastTasbih());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Belum ada tasbih yang dibuka")),
              );
            }
          },
          child: Container(
            width: double.infinity,
            height: screen.height * 0.23,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFA8FBD3), Color(0xFF4FB7B3)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Row(
                children: [
                  // === Glow Circular Progress ===
                  SizedBox(
                    width: screen.width * 0.36,
                    height: screen.width * 0.36,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow
                        Container(
                          width: screen.width * 0.36,
                          height: screen.width * 0.36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.55),
                                blurRadius: 32,
                                spreadRadius: 6,
                              ),
                            ],
                          ),
                        ),

                        // Progress Indicator
                        Container(
                          width: screen.width * 0.30,
                          height: screen.width * 0.30,
                          child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 12,
                            value: ((lastTasbihCount ?? 0) % 10000) / 10000,
                            backgroundColor: Colors.white.withOpacity(0.2),
                          ),
                        ),

                        // Number in Center
                        Text(
                          "${lastTasbihCount ?? 0}",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // TEKS KANAN — Expanded BIAR TIDAK OVERFLOW
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.network(
                              "https://img.icons8.com/external-smashingstocks-detailed-outline-smashing-stocks/66/external-tasbih-ramadan-and-eid-smashingstocks-detailed-outline-smashing-stocks.png",
                              color: Colors.black54,
                              width: 28,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Last Count",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          lastTasbih ?? "Belum Ada Yang Dibaca",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 25),

        // ISLAMIC QUOTES
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFA1E3F9), Color(0xFF578FCA)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Islamic Quotes",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: isLoadingQuote
                    ? const Center(
                        child: Text(
                          "Loading...",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              "\"${currentQuote!.text}\"",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF31326F),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentQuote!.arabic,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.amiri(
                                color: const Color(0xFF31326F),
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "- ${currentQuote!.source} -",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}
