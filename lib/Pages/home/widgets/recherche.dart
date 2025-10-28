import 'package:flutter/material.dart';

class Recherche extends StatelessWidget {
  const Recherche({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      /* height: 100,
      color: Colors.yellow, */
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Stack(
        // Utilisation de Stack pour superposer les widgets
        children: [
          // Le champ de recherche
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              hintText: 'Rechercher votre pharmacie',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 47, 159, 229),
              ),
              child: const Icon(
                Icons.mic_none_outlined,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
