import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularProgressWidget extends StatelessWidget {
  final double progress;
  final int count;
  final VoidCallback onTap;

  const CircularProgressWidget({
    super.key,
    required this.progress,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.6;

    return GestureDetector(
      onTap: onTap,
      child: CircularPercentIndicator(
        radius: size / 2.5,
        lineWidth: 15,
        percent: progress,
        center: Text(
          "$count",
          style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        progressColor: const Color(0xFF4FB7B3),
        backgroundColor: Colors.grey[200]!,
        circularStrokeCap: CircularStrokeCap.round,
        animation: true,
        animationDuration: 300,
      ),
    );
  }
}
