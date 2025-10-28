import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/tasbih_model.dart';
import '../../widgets/bottom_nav.dart';
import 'tasbih_page.dart';

class TasbihListPage extends StatefulWidget {
  const TasbihListPage({super.key});

  @override
  State<TasbihListPage> createState() => _TasbihListPageState();
}

class _TasbihListPageState extends State<TasbihListPage> {
  List<Tasbih> allTasbih = [];
  List<Tasbih> filteredTasbih = [];
  final TextEditingController _searchController = TextEditingController();
  final int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadTasbihData();
    _searchController.addListener(_filterSearch);
  }

  Future<void> _loadTasbihData() async {
    final data = await rootBundle.loadString('lib/data/dummy_data.json');
    final jsonResult = json.decode(data);
    final prefs = await SharedPreferences.getInstance();

    final List tasbihList = jsonResult['tasbih'] ?? [];
    setState(() {
      allTasbih = tasbihList.map((e) {
        final nama = e['nama'];
        final count = prefs.getInt('tasbih_$nama') ?? 0;
        return Tasbih(nama: nama, count: count);
      }).toList();
      filteredTasbih = allTasbih;
    });
  }

  void _filterSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredTasbih = allTasbih
          .where((t) => t.nama.toLowerCase().contains(query))
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
    final screen = MediaQuery.of(context).size;
    final double w = screen.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header mirip DoaList
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black87,
                      size: 20,
                    ),
                  ),
                  Text(
                    "List Tasbih",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF4FB7B3),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 15),

              // 🔹 Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0x198789A3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Color(0xFF4FB7B3)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Cari tasbih...",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[600],
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

              // 🔹 List Tasbih (mirip card Doa)
              Expanded(
                child: filteredTasbih.isEmpty
                    ? Center(
                        child: Text(
                          "Tidak ada tasbih ditemukan",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredTasbih.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final t = filteredTasbih[index];
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TasbihPage(tasbih: t),
                                ),
                              );
                              _loadTasbihData(); // refresh nilai terakhir
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0x198789A3),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    t.nama,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF4FB7B3),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Terakhir: ${t.count}",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[700],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
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
