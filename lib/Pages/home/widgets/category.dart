import 'package:flutter/material.dart';
import 'package:myagemas/Pages/home/widgets/Produits.dart';

class Category extends StatelessWidget {
  Category({super.key});

  final categories = [
    {
      'icon': Icons.person_4_outlined,
      'label': 'Adhérents',
      'color': Color(0xFF605CF4),
    },
    {
      'icon': Icons.people_outline_sharp,
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
  // L'arrièere-plan de la section catégorie en blanc avec des coins arrondis en haut
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
      // Le contenu de la section catégorie
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            /* color: Colors.blueGrey, */
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: 25,
              ), // Especment à gauche à droite
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) => Column(
                children: [
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: categories[index]['color'] as Color,
                    ),
                    child: Icon(
                      categories[index]['icon'] as IconData,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    categories[index]['label'] as String,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              )),
              separatorBuilder: ((context, index) => const SizedBox(width: 33)),
              itemCount: categories.length,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              'retrouvez les pharmacies',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Produits(),
        ],
      ),
    );
  }
}
