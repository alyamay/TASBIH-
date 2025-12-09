import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/collection_manager.dart';
import '../utils/theme_manager.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> collections = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final c = await CollectionManager.getCollections();
    setState(() => collections = c);
  }

  Future<void> _addCollectionDialog() async {
    final isDark = ThemeManager.of(context).isDark.value;
    final ctrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Tambah Koleksi Baru',
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : const Color(0xFF230E4E),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: ctrl,
          cursorColor: const Color(0xFF4FB7B3),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Nama koleksi',
            hintStyle: GoogleFonts.poppins(
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDark ? Colors.white30 : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF4FB7B3),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4FB7B3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final name = ctrl.text.trim();
              if (name.isNotEmpty) {
                await CollectionManager.addCollection(name);
                await _load();
              }
              Navigator.pop(context);
            },
            child: Text(
              'Simpan',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _renameDialog(String oldName) async {
    final isDark = ThemeManager.of(context).isDark.value;
    final ctrl = TextEditingController(text: oldName);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Ubah Nama Koleksi',
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : const Color(0xFF230E4E),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: ctrl,
          cursorColor: const Color(0xFF4FB7B3),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Nama baru...',
            hintStyle: GoogleFonts.poppins(
              color: isDark ? Colors.white38 : Colors.grey[400],
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDark ? Colors.white30 : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF4FB7B3),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final newName = ctrl.text.trim();
              if (newName.isNotEmpty && newName != oldName) {
                await CollectionManager.renameCollection(oldName, newName);
                await _load();
              }
              Navigator.pop(context);
            },
            child: Text(
              'Simpan',
              style: GoogleFonts.poppins(color: const Color(0xFF4FB7B3)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCollection(String name) async {
    final isDark = ThemeManager.of(context).isDark.value;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Hapus Koleksi?',
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : const Color(0xFF230E4E),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus koleksi "$name"? Semua item di dalamnya juga akan dihapus.',
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white70 : Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (ok == true) {
      await CollectionManager.deleteCollection(name);
      await _load();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Koleksi "$name" dihapus'),
          backgroundColor: Colors.redAccent.withOpacity(0.85),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeManager.of(context).isDark.value;

    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF230E4E);
    final folderBg = isDark ? const Color(0xFF1E1E1E) : const Color(0x0F4FB7B3);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
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
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    'Bookmarks',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF4FB7B3),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 28),
                ],
              ),

              const SizedBox(height: 20),

              // ADD COLLECTION BUTTON
              GestureDetector(
                onTap: _addCollectionDialog,
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_box_outlined,
                      color: Color(0xFF4FB7B3),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add new collection',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF4FB7B3),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // LIST
              Expanded(
                child: collections.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada koleksi',
                          style: GoogleFonts.poppins(
                            color: isDark ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: collections.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (_, i) {
                          final c = collections[i];
                          final name = c['name'] as String;
                          final count = (c['items'] as List).length;

                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/bookmark-list',
                                arguments: {'name': collections[i]['name']},
                              ).then((_) => _load());
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: folderBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.folder,
                                        color: Color(0xFF4FB7B3),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: GoogleFonts.poppins(
                                              color: textColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            '$count items',
                                            style: GoogleFonts.poppins(
                                              color: isDark
                                                  ? Colors.white60
                                                  : const Color(0xFF8789A3),
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  PopupMenuButton<String>(
                                    color: isDark
                                        ? const Color(0xFF1E1E1E)
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: isDark ? 0 : 3,
                                    onSelected: (v) {
                                      if (v == 'rename') _renameDialog(name);
                                      if (v == 'delete')
                                        _deleteCollection(name);
                                    },
                                    itemBuilder: (_) => [
                                      PopupMenuItem(
                                        value: 'rename',
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.edit_outlined,
                                              color: Color(0xFF4FB7B3),
                                              size: 20,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Rename',
                                              style: GoogleFonts.poppins(
                                                color: textColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.delete_outline,
                                              color: Colors.redAccent,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'Delete',
                                              style: GoogleFonts.poppins(
                                                color: textColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
