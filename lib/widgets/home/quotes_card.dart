// lib/widgets/home/quotes_card.dart
import 'package:flutter/material.dart';

class QuotesCard extends StatelessWidget {
  final Map<String, dynamic>? dummyData;

  const QuotesCard({super.key, required this.dummyData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Islamic Quotes", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          dummyData == null
              ? const Text("Memuat quotes...")
              : Column(
                  children: (dummyData!['quotes'] as List<dynamic>).map((q) => Padding(padding: const EdgeInsets.symmetric(vertical: 6.0), child: Row(children: [const Icon(Icons.format_quote, size: 18, color: Colors.grey), const SizedBox(width: 8), Expanded(child: Text(q.toString()))]))).toList(),
                ),
        ],
      ),
    );
  }
}
