// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myagemas/Pages/home/widgets/Headers.dart';
import 'package:myagemas/Pages/home/widgets/category.dart';
import 'package:myagemas/Pages/home/widgets/recherche.dart';

// Page d'accueil de l'application
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  // Construction de l'interface utilisateur
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 155, 209),
      body: Stack(
        children: [
          // 🔹 Image de fond
          Image.asset(
            'assets/images/icon.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // 🔹 Effet flou
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // ajuste le flou
            child: Container(
              color: Colors.white.withOpacity(0.2), // léger voile blanc
            ),
          ),

          // 🔹 Ton contenu au-dessus
          SingleChildScrollView(
            // Permet le défilement si le contenu dépasse l'écran
            child: Stack(
              children: [
                Transform(
                  transform: Matrix4.identity()..rotateZ(20),
                  origin: const Offset(150, 50),
                  child: Image.asset('assets/images/favicon.png', width: 200),
                ),
                Positioned(
                  right: 0,
                  top: 200,
                  child: Transform(
                    transform: Matrix4.identity()..rotateZ(20),
                    origin: const Offset(200, 50),
                    child: Image.asset('assets/images/favicon.png', width: 200),
                  ),
                ),
                Column(children: [HeaderSection(), Recherche(), Category()]),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }

  /* La barre de navigation en bas */
  Widget NavigationBar() {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 169, 205, 235),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            selectedItemColor: Colors.blue,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                label: 'Accueil',
                icon: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.home_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Info',
                icon: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.info_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Déconnexion',
                icon: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person_2_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
