import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/collection_manager.dart';
import '../utils/theme_manager.dart';
import '../models/doa_model.dart';
import '../services/doa_service.dart';

class BookmarkListPage extends StatefulWidget {
  const BookmarkListPage({super.key});

  @override
  State<BookmarkListPage> createState() => _BookmarkListPageState();
}

class _BookmarkListPageState extends State<BookmarkListPage> {
  String collectionName = "";
  List<Doa> doaList = [];

  // [PERUBAHAN 1]: Future untuk FutureBuilder
  late Future<void> _loadFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // [PERUBAHAN 2]: Inisialisasi Future
    _loadFuture = _load();
  }

  // [PERUBAHAN 3]: Fungsi _load
  Future<void> _load() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    collectionName = args?['name'] ?? "";

    // Ambil koleksi
    final allCollections = await CollectionManager.getCollections();
    final col = allCollections.firstWhere(
      (c) => c['name'] == collectionName,
      orElse: () => {'name': collectionName, 'items': <int>[]},
    );

    final items = List<int>.from(col['items'] ?? []);

    // Ambil semua doa
    final allDoa = await DoaService.fetchAllDoa();

    setState(() {
      doaList = allDoa.where((d) => items.contains(d.id)).toList();
    });
  }

  Future<void> _removeItem(Doa doa) async {
    await CollectionManager.removeItem(collectionName, doa.id);

    setState(() {
      _loadFuture = _load();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dihapus dari $collectionName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeManager.of(context).isDark.value;
    final primaryColor = const Color(0xFF4FB7B3);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          child: Column(
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: isDark ? Colors.white : Colors.black87,
                      size: 20,
                    ),
                  ),
                  Text(
                    collectionName,
                    style: GoogleFonts.poppins(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),

              const SizedBox(height: 20),

              // DAFTAR DENGAN FUTUREBUILDER
              Expanded(
                child: FutureBuilder<void>(
                  future: _loadFuture,
                  builder: (context, snapshot) {
                    // LOADING
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      );
                    }

                    // ERROR
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Gagal memuat data: ${snapshot.error}',
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      );
                    }

                    // KOSONG
                    if (doaList.isEmpty) {
                      return Center(
                        child: Text(
                          'Belum ada doa dalam koleksi ini',
                          style: GoogleFonts.poppins(
                            color: isDark ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      );
                    }

                    // LIST DOA
                    return ListView.builder(
                      itemCount: doaList.length,
                      itemBuilder: (_, i) {
                        final doa = doaList[i];

                        final itemBg = isDark
                            ? const Color(0xFF1E1E1E)
                            : const Color(0xFFF8FBFF);

                        final itemTextColor = isDark
                            ? Colors.white
                            : const Color(0xFF230E4E);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: itemBg,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  doa.judul,
                                  style: GoogleFonts.poppins(
                                    color: itemTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => _removeItem(doa),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: primaryColor,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/doa',
                                        arguments: {'id': doa.id},
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
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
