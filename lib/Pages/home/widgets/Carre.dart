import 'package:flutter/material.dart';

class Carre extends StatelessWidget {
  final String chemin;
  final VoidCallback? onTap;

  const Carre({super.key, required this.chemin, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Image.asset(chemin, height: 20),
      ),
    );
  }
}
