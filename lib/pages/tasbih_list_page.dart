import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/models/tasbih_model.dart';
import 'package:project/utils/theme_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tasbih_page.dart';

class TasbihListPage extends StatefulWidget {
  const TasbihListPage({super.key});

  @override
  State<TasbihListPage> createState() => _TasbihListPageState();
}

class _TasbihListPageState extends State<TasbihListPage> {
  bool isLoading = true;

  List<Tasbih> allTasbih = [];
  List<Tasbih> filteredTasbih = [];
  final TextEditingController _searchController = TextEditingController();

  // Default tasbih yang kamu miliki
  final defaultTasbih = const [
    "Istighfar",
    "Subhanallah",
    "Alhamdulillah",
    "Allahu Akbar",
  ];

  @override
  void initState() {
    super.initState();
    _loadTasbihData();
    _searchController.addListener(_filterSearch);
  }

  Future<void> _loadTasbihData() async {
    setState(() => isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      final data = doc.data();
      final counts = data?["tasbihCounts"] ?? {};

      // Gabungkan default list + jumlah count Firebase
      allTasbih = defaultTasbih.map((name) {
        return Tasbih(nama: name, count: counts[name] ?? 0);
      }).toList();

      filteredTasbih = allTasbih;
    } catch (e) {
      print("Error loading tasbih: $e");
    }

    setState(() => isLoading = false);
  }

  void _filterSearch() {
    final q = _searchController.text.toLowerCase();

    setState(() {
      filteredTasbih = allTasbih
          .where((t) => t.nama.toLowerCase().contains(q))
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

    final bg = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF230E4E);
    final searchBg = isDark ? const Color(0x33FFFFFF) : const Color(0x198789A3);
    final cardBg = isDark ? const Color(0x22FFFFFF) : const Color(0x198789A3);

    final screen = MediaQuery.of(context).size;
    final double w = screen.width;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: 10),
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

              // SEARCH BOX
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
                        decoration: InputDecoration(
                          hintText: "Cari tasbih...",
                          hintStyle: GoogleFonts.poppins(
                            color: isDark ? Colors.white70 : Colors.grey[600],
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

              // LIST
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4FB7B3),
                        ),
                      )
                    : filteredTasbih.isEmpty
                    ? Center(
                        child: Text(
                          "Tidak ada tasbih ditemukan",
                          style: GoogleFonts.poppins(
                            color: isDark ? Colors.white70 : Colors.grey[600],
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
                              _loadTasbihData();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: cardBg,
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
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.grey[700],
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
