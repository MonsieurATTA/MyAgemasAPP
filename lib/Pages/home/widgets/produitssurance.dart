import 'package:flutter/material.dart';
import 'package:myagemas/Pages/detail/pageautomoto.dart';
import 'package:myagemas/Pages/detail/pagefamssur.dart';
import 'package:myagemas/Pages/detail/pagemrh.dart';
import 'package:myagemas/Pages/detail/pagesante.dart';
import 'package:myagemas/Pages/home/widgets/btnpharmacie.dart';
import 'package:myagemas/Pages/home/widgets/conseilsante.dart';
import 'package:myagemas/Pages/detail/pagmoka.dart';
/* import 'package:myagemas/Pages/home/widgets/Produits.dart'; */

//A LIRE
// LA page (Blanche) où j'appelle deux sous page "produit.dart","Conseilsante.dart" et j'affiche toues les inforamations sur les contrats d'assuarance

// ⚠️ Assure-toi que ces pages existent bien
// import 'page_adherent_moka.dart';
// import 'page_auto_moto.dart';
// import 'page_sante.dart';
// import 'page_famssur.dart';
// import 'page_mrh.dart';
// import 'produits.dart';
// import 'conseilsante.dart';

class Category extends StatelessWidget {
  Category({super.key});

  final List<Map<String, dynamic>> categories = [
    {
      'icon': Icons.person_4_outlined,
      'label': 'Moka pharmacie',
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

  // Espacements standards
  static const double sectionSpacing = 24;
  static const double titleSpacing = 12;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1090,
      decoration: const BoxDecoration(
        color: Color(0xFFF6F8FF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= VOS ASSURANCES =================
          const SizedBox(height: sectionSpacing),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'VOS ASSURANCES',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: titleSpacing),

          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 24),
              itemBuilder: (context, index) {
                final category = categories[index];
                final String label = category['label'];

                return InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    if (label == 'Moka pharmacie') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PageadherentMOKA(),
                        ),
                      );
                    } else if (label == 'Auto-Moto') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PageAutoMoto()),
                      );
                    } else if (label == 'Sante') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PageSante()),
                      );
                    } else if (label == 'Famssur') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PageFamssur()),
                      );
                    } else if (label == 'MRH') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PageMRH()),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: category['color'],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          category['icon'],
                          size: 40,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ================= PHARMACIES =================
          const SizedBox(height: sectionSpacing),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'NOS PHARMACIES PARTENAIRES',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: titleSpacing),

          Produits(),

          // ================= CONSEILS SANTÉ =================
          const SizedBox(height: sectionSpacing),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'CONSEILS SANTE',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: titleSpacing),

          Conseilsante(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
