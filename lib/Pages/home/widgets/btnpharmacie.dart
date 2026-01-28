import 'package:flutter/material.dart';
import 'package:myagemas/Pages/detail/affichecommune.dart';
import 'package:myagemas/models/assurance.dart';

//A Lire
// OBJET DE CETTE PARTIE : C'est là où on clique pour afficher la liste des commune pour pouvoir retrouver les pharmacies

class Produits extends StatelessWidget {
  Produits({super.key});

  final List<Assurance> assurances = Assurance.assurances();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      /* color: Colors.blue, */
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 10,
        ), // Especment à gauche à droite
        scrollDirection: Axis.horizontal,
        itemBuilder: ((context, index) => GestureDetector(
          onTap: (() => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: ((context) => PharmaciesApp())))),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              child: ClipRRect(child: Image.asset(assurances[index].bgImage)),
            ),
          ),
        )),
        separatorBuilder: ((context, index) => SizedBox(width: 10)),
        itemCount: assurances.length,
      ),
    );
  }
}
