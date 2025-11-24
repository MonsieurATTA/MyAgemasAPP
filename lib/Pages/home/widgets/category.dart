import 'package:flutter/material.dart';
import 'package:myagemas/Pages/detail/pageautomoto.dart';
import 'package:myagemas/Pages/detail/pagefamssur.dart';
import 'package:myagemas/Pages/detail/pagemrh.dart';
import 'package:myagemas/Pages/detail/pagesante.dart';
import 'package:myagemas/Pages/home/widgets/Produits.dart';
import 'package:myagemas/Pages/home/widgets/conseilsante.dart';
import 'package:myagemas/Pages/detail/pagmoka.dart';
/* import 'package:myagemas/Pages/home/widgets/Produits.dart'; */

//A LIRE
// LA page (Blanche) où j'appelle deux sous page "produit.dart","Conseilsante.dart" et j'affiche toues les inforamations sur les contrats d'assuarance

class Category extends StatelessWidget {
  Category({super.key});

  final categories = [
    {
      'icon': Icons.person_4_outlined,
      'label': 'Moka',
      'color': Color.fromARGB(255, 11, 54, 230),
    },
    {
      'icon': Icons.motorcycle_sharp,
      'label': 'Auto-Moto',
      'color': Color.fromARGB(255, 241, 241, 44),
    },
    {
      'icon': Icons.medical_services,
      'label': 'Sante',
      'color': Color.fromARGB(255, 0, 195, 255),
    },
    {
      'icon': Icons.mediation_outlined,
      'label': 'Famssur',
      'color': Color(0xFFFFB800),
    },
    {
      'icon': Icons.house,
      'label': 'MRH',
      'color': Color.fromARGB(255, 117, 221, 47),
    },
  ];

  @override
  // L'arrièere-plan de la section catégorie en blanc avec des coins arrondis en haut
  Widget build(BuildContext context) {
    return Container(
      height: 1000,
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
              itemBuilder: ((context, index) {
                final String label = categories[index]['label'] as String;
                return InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    if (label == 'Moka') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PageadherentMOKA(),
                        ),
                      );
                    } else if (label == 'Auto-Moto') {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PageAutoMoto()),
                      );
                    } else if (label == 'Sante') {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PageSante()),
                      );
                    } else if (label == 'Famssur') {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PageFamssur()),
                      );
                    } else if (label == 'MRH') {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PageMRH()),
                      );
                    }
                  },
                  child: Column(
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
                        label,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              separatorBuilder: ((context, index) => const SizedBox(width: 33)),
              itemCount: categories.length,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              'retrouvez les pharmacies',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                height: 3,
              ),
            ),
          ),
          Produits(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              'Conseils santé',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                height: 3,
              ),
            ),
          ),
          Conseilsante(),
        ],
      ),
    );
  }
}
