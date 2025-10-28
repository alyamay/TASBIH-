import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LastReadCard extends StatelessWidget {
  final String? lastRead;

  const LastReadCard({super.key, this.lastRead});

  @override
  Widget build(BuildContext context) {
    final title = lastRead ?? 'Belum ada doa terakhir';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4FB7B3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu_book, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Last Read",
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 12)),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange[700],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.bookmark, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}
