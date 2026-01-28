import 'package:flutter/material.dart';

class info extends StatelessWidget {
  const info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("À propos de nous"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 170, 243),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Logo ou image de l'entreprise
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/agemas-01.png',
                        width: 150,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 0),
                  const Text(
                    "AGEMAS ASSURANCE",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// 🔹 Description
            const Text(
              "Qui sommes-nous ?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "AGEMAS Assurance est une société de courtage en assurance de droit ivoirien,créée en 1997."
              "Depuis plus de 25ans, nous mettons notre expertise au service de la protection sociale et patrimoniale avec un engagement constant en vers les attentes concrètes des populations."
              "Grâce à une présence nationale à travers nos agences à Abidjan, Bouaké, Daloa, Korhogo, Kotobi et San Pedro, nous offrons un service de proximité ouvert à toutesles catégories de la société.",
              style: TextStyle(fontSize: 15, height: 1.5),
            ),

            const SizedBox(height: 20),

            /// 🔹 Mission
            const Text(
              "Notre mission",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Rendre l'assurance simple, accessible et utile à tous."
              "Concevoir des produits adaptés aux besoins réels des populations, dans un esprit de solidarité et d'inclusion sociale. ",

              style: TextStyle(fontSize: 15, height: 1.5),
            ),

            const SizedBox(height: 20),

            /// 🔹 Valeurs
            const Text(
              "Nos valeurs",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildValueItem("✔ Professionnalisme"),
            _buildValueItem("✔ Transparence"),
            _buildValueItem("✔ Innovation"),
            _buildValueItem("✔ Engagement"),

            const SizedBox(height: 25),

            /// 🔹 Contact
            const Text(
              "Contact",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: const Text("+225 27 22 31 74 59"),
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: const Text("+225 01 03 64 49 42"),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text("contact@agemas-ci.com"),
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.blue),
              title: const Text(
                "Abidjan-Cocody II Plateaux Vallon, Cité Lémania 2ème entrée",
              ),
            ),

            const SizedBox(height: 30),

            /// 🔹 Footer
            Center(
              child: Text(
                "© 2026 - AGEMAS ASSURANCE",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget pour les valeurs
  static Widget _buildValueItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text, style: const TextStyle(fontSize: 15)),
    );
  }
}
