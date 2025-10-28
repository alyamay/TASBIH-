import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/doa_model.dart';
import '../../widgets/bottom_nav.dart';
import 'doa_page.dart';

class DoaListPage extends StatefulWidget {
  const DoaListPage({super.key});

  @override
  State<DoaListPage> createState() => _DoaListPageState();
}

class _DoaListPageState extends State<DoaListPage> {
  List<Doa> allDoa = [];
  List<Doa> filteredDoa = [];
  final TextEditingController _searchController = TextEditingController();
  final int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadDoaData();
    _searchController.addListener(_filterSearch);
  }

  Future<void> _loadDoaData() async {
    final data = await rootBundle.loadString('lib/data/dummy_data.json');
    final jsonResult = json.decode(data);

    final List doaList = jsonResult['doa'] ?? [];
    setState(() {
      allDoa = doaList.map((e) => Doa.fromJson(e)).toList();
      filteredDoa = allDoa;
    });
  }

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
              // Header
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
                    "Daily Dua",
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

              // Search Bar
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
                          hintText: "Cari doa...",
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

              // List Doa
              Expanded(
                child: filteredDoa.isEmpty
                    ? Center(
                        child: Text(
                          "Tidak ada doa ditemukan",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
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
                                arguments: {'judul': doa.judul},
                              );
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
                              child: Text(
                                doa.judul,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF4FB7B3),
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
