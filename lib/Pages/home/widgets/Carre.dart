import 'package:flutter/material.dart';

class Carre extends StatelessWidget {
  final String chemin;
  const Carre({super.key, required this.chemin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Image.asset(chemin, height: 20),
    );
  }
}
