import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/models/tasbih_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:async';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String? lastReadTitle;
  String? lastTasbih;
  int? lastTasbihCount;
  String? currentQuote;
  List<String>? quotesList;

  @override
  void initState() {
    super.initState();
    _loadLastRead();
    _loadLastTasbih();
    loadQuotes();
  }

  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => lastReadTitle = prefs.getString('last_read'));
  }

  Future<void> _loadLastTasbih() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastTasbih = prefs.getString('last_tasbih');
      lastTasbihCount = prefs.getInt('tasbih_${lastTasbih ?? ''}') ?? 0;
    });
  }

  Future<void> loadQuotes() async {
    final raw = await rootBundle.loadString('lib/data/dummy_data.json');
    final data = jsonDecode(raw);
    quotesList = List<String>.from(data['quotes']);
    _randomizeQuote();
  }

  void _randomizeQuote() {
    if (quotesList == null) return;
    quotesList!.shuffle();
    setState(() => currentQuote = quotesList!.first);
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: screen.width * 0.06,
        vertical: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TASBIH+",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF4FB7B3),
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
                    "Alya Maysa",
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
          // 🔹 Last Read card (klik untuk buka doa terakhir)
          GestureDetector(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final saved = prefs.getString('last_read');
              if (saved != null && saved.isNotEmpty) {
                Navigator.pushNamed(
                  context,
                  '/doa',
                  arguments: {'judul': saved},
                );
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

          // 🔹 Tasbih counter card
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
                ).then((_) {
                  _loadLastTasbih();
                });
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: screen.width * 0.25,
                          height: screen.width * 0.25,
                          child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 10,
                            value: ((lastTasbihCount ?? 0) % 10000) / 10000,
                            backgroundColor: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        Text(
                          "${lastTasbihCount ?? 0}",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
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
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // 🔹 Islamic Quotes (fixed size + scrollable text)
          Container(
            width: double.infinity,
            height: 190,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFA1E3F9), Color(0xFF578FCA)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
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
                  child: currentQuote == null
                      ? const Center(
                          child: Text(
                            "Loading...",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Text(
                            "\"$currentQuote\"",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF31326F),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
