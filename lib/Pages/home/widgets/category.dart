import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  Category({super.key});

  final categories = [
    {
      'icon': Icons.person_3_sharp,
      'label': 'Adhérents',
      'color': Color(0xFF605CF4),
    },
    {
      'icon': Icons.people_outline,
      'label': 'Bénéficiaires',
      'color': Color(0xFFFC77A6),
    },
    {
      'icon': Icons.pattern_outlined,
      'label': 'partenaires',
      'color': Color(0xFF00C9A7),
    },
    {
      'icon': Icons.health_and_safety,
      'label': 'Santé',
      'color': Color(0xFFFFB800),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      decoration: const BoxDecoration(
        color: Color(0xFFF6F8FF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
