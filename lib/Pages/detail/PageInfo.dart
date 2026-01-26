import 'package:flutter/material.dart';

class info extends StatelessWidget {
  const info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("À propos"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // =========================
            // ZONE IMAGE / LOGO
            // =========================
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  "Image / Logo ici",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // ZONE NOUVEAUTÉS
            // =========================
            _section(
              title: "Nouveautés",
              child: _emptyBox(
                "Du nouveau à AGEMAS ASSURANCE, désormais profiter de MOKA PLUS",
              ),
            ),

            const SizedBox(height: 16),

            // =========================
            // ZONE INFORMATIONS
            // =========================
            _section(
              title: "Informations",
              child: _emptyBox(
                "Nous accompagnons : les Particuliers, Entreprises et Groupements professionnels,Fonctionnaires et Agents de l'Etat, Salariés d'Entreprises Privées, Groupements Communautaires et Mutuelles.",
              ),
            ),

            const SizedBox(height: 16),

            // =========================
            // ZONE CONTACT
            // =========================
            _section(
              title: "Contact",
              child: Column(
                children: [
                  _emptyBox("+225 27 22 31 74 59; +225 01 03 64 49 42 "),
                  const SizedBox(height: 8),
                  _emptyBox("contact@agemas-ci.com"),
                  const SizedBox(height: 8),
                  _emptyBox(
                    "Siège social : Abidjan-Cocody II plateaix - Vallon, Cité Lémania 2eme entrée, 2eme villa à droite",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =========================
            // ZONE SITE INTERNET
            // =========================
            _section(
              title: "Site Internet",
              child: _emptyBox("https://agemas-ci.com/"),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // WIDGET SECTION (TITRE + CONTENU)
  // =========================
  Widget _section({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  // =========================
  // ZONE VIDE MODIFIABLE
  // =========================
  Widget _emptyBox(String placeholder) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(placeholder, style: const TextStyle(color: Colors.grey)),
    );
  }
}
