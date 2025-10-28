import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Page'),
      ),
      body: Center(
        child: const Text('This is the Favorite Page'),
      ),
    );
  }
}