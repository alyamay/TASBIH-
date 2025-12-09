import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/doa_model.dart';
import '../../utils/theme_manager.dart';
import '../../utils/collection_manager.dart';

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  Doa? doa;
  bool loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final id = args?['id'];

    if (id == null) {
      setState(() => loading = false);
      return;
    }

    print("DEBUG: Memuat detail doa id = $id");

    try {
      final url = "https://open-api.my.id/api/doa/$id";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          doa = Doa.fromApi(data);
          loading = false;
        });

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('last_read_judul', doa!.judul);
        prefs.setInt('last_read_id', doa!.id);
      } else {
        print("API error: ${response.statusCode}");
        setState(() => loading = false);
      }
    } catch (e) {
      print("ERROR fetching doa detail: $e");
      setState(() => loading = false);
    }
  }

  // pilih koleksi
  void _chooseCollection() async {
    if (doa == null) return;

    final collections = await CollectionManager.getCollections();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Simpan ke Koleksi",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF230E4E),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: collections.length,
            itemBuilder: (_, i) {
              final name = collections[i]['name'];

              return ListTile(
                title: Text(name, style: GoogleFonts.poppins()),
                onTap: () async {
                  await CollectionManager.addItem(name, doa!.id);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ditambahkan ke "$name"'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeManager.of(context).isDark.value;

    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF230E4E);
    final subText = isDark ? Colors.white70 : const Color(0xFF4FB7B3);
    final cardBg = isDark ? const Color(0xFF1E1E1E) : const Color(0x0C121931);

    return Scaffold(
      backgroundColor: bgColor,
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4FB7B3)),
            )
          : doa == null
          ? Center(
              child: Text(
                "Data doa tidak ditemukan",
                style: GoogleFonts.poppins(color: textColor),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "TASBIH+",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF4FB7B3),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.bookmark_add_outlined,
                            color: Color(0xFF4FB7B3),
                          ),
                          onPressed: _chooseCollection,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // CARD JUDUL
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 35,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFADEED9), Color(0xFF0ABAB5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Text(
                        doa!.judul,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ISI DOA
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          Text(
                            doa!.arab,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.amiri(
                              color: textColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            doa!.latin,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: subText,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            doa!.arti,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 15,
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
