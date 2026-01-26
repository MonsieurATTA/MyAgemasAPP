import 'package:flutter/material.dart';

//A lIRE
// OBJECTIF DE CETTE PAGE : J'affiche le debut de page avec le profile

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(
          context,
        ).padding.top, // Pour éviter le chevauchement avec la barre d'état
        left: 25,
        right: 25,
      ),
      /* height: 200, */
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Espace entre les éléments le texte et la photo d'utilisateur
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alignement à gauche du texte
            children: const [
              Text(
                'Bienvenue,',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Chez AGEMAS ASSURANCE',
                style: TextStyle(fontSize: 19, color: Colors.white),
              ),
            ],
          ),
          CircleAvatar(
            child: Image.asset('assets/images/user.jpeg', fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
