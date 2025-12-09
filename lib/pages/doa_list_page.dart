import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../models/doa_model.dart';
import '../../utils/theme_manager.dart';

class DoaListPage extends StatefulWidget {
  const DoaListPage({super.key});

  @override
  State<DoaListPage> createState() => _DoaListPageState();
}

class _DoaListPageState extends State<DoaListPage> {
  List<Doa> allDoa = [];
  List<Doa> filteredDoa = [];
  final TextEditingController _searchController = TextEditingController();

  // **[PENAMBAHAN 1]: Variabel State untuk Loading**
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoaFromApi();
    _searchController.addListener(_filterSearch);
  }

  // =====================================================
  // LOAD API
  // =====================================================
  Future<void> _loadDoaFromApi() async {
    const url = "https://open-api.my.id/api/doa";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        setState(() {
          allDoa = data.map((e) => Doa.fromApi(e)).toList();
          filteredDoa = allDoa;
          // Set isLoading menjadi false setelah data berhasil dimuat
          isLoading = false;
        });
      } else {
        print("API Error: ${response.statusCode}");
        setState(() {
          isLoading = false; // Jika error, hentikan loading
        });
      }
    } catch (e) {
      print("Load API error: $e");
      setState(() {
        isLoading = false; // Jika error, hentikan loading
      });
    }
  }

  // =====================================================
  // SEARCH FILTER
  // =====================================================
  void _filterSearch() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredDoa = allDoa
          .where((d) => d.judul.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeManager.of(context).isDark.value;

    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF230E4E);
    final searchBg = isDark ? const Color(0x33FFFFFF) : const Color(0x198789A3);
    final itemBg = isDark ? const Color(0x22FFFFFF) : const Color(0x198789A3);
    final primaryColor = const Color(0xFF4FB7B3); // Warna utama untuk loading

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: textColor,
                      size: 20,
                    ),
                  ),
                  Text(
                    "Daily Dua",
                    style: GoogleFonts.poppins(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),

              const SizedBox(height: 15),

              // SEARCH BAR
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: searchBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Color(0xFF4FB7B3)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: textColor),
                        // **[PENTING]: Nonaktifkan TextField saat loading**
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          hintText: "Cari doa...",
                          hintStyle: GoogleFonts.poppins(
                            color: isDark ? Colors.white60 : Colors.grey[600],
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // **[PERUBAHAN UTAMA]: Kontrol Tampilan berdasarkan isLoading**
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: primaryColor, // Menggunakan warna tema
                        ),
                      )
                    : filteredDoa.isEmpty
                    ? Center(
                        child: Text(
                          // Perbarui teks ini agar lebih spesifik jika setelah loading
                          _searchController.text.isNotEmpty
                              ? "Tidak ada doa yang cocok dengan pencarian."
                              : "Tidak ada doa ditemukan (API mungkin kosong).",
                          style: GoogleFonts.poppins(
                            color: isDark ? Colors.white70 : Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredDoa.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final doa = filteredDoa[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/doa',
                                arguments: {'id': doa.id},
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: itemBg,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                doa.judul,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
