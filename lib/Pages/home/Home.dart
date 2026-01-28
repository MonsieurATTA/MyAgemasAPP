import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myagemas/Pages/detail/PageInfo.dart';

import 'package:myagemas/Pages/home/widgets/Headers.dart';
import 'package:myagemas/Pages/home/widgets/produitssurance.dart';
import 'package:myagemas/Pages/home/widgets/recherche.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 155, 209),
      body: Stack(
        children: [
          /// Image de fond
          Image.asset(
            'assets/images/icon.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          /// Effet flou
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.white.withOpacity(0.2)),
          ),

          /// Contenu principal
          SingleChildScrollView(
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
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  /// ===============================
  /// BOTTOM NAVIGATION BAR
  /// ===============================
  Widget _bottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 169, 205, 235),
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
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,

          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            /// ACCUEIL
            if (index == 0) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            }

            /// INFO
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const info()),
              );
            }

            /// DÉCONNEXION (FERMETURE APP)
            if (index == 2) {
              SystemNavigator.pop();
            }
          },

          items: const [
            BottomNavigationBarItem(
              label: 'Accueil',
              icon: Icon(Icons.home_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Info',
              icon: Icon(Icons.info_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Déconnexion',
              icon: Icon(Icons.power_settings_new_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
