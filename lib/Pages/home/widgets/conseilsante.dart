import 'package:flutter/material.dart';
import 'package:myagemas/models/conseilassurance.dart';

class Conseilsante extends StatelessWidget {
  Conseilsante({super.key});

  final List<ConseilAssurance> sante = ConseilAssurance.sante();

  @override
  Widget build(BuildContext context) {
    return Container(
      /* color: Colors.red, */
      padding: const EdgeInsets.all(15),
      child: Column(
        children: sante
            .map(
              (sante) => Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 1),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(sante.bgImage, width: 60),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            sante.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
