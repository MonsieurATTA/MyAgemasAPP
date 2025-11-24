import 'package:flutter/material.dart';
import 'package:myagemas/Pages/home/widgets/Carre.dart';
import 'package:myagemas/Pages/home/widgets/Input.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 30),
            margin: EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Connexion",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text("Bienvenue sur votre application MY-AGEMAS"),

                  SizedBox(height: 25),

                  SizedBox(height: 30),
                  Form(
                    child: Column(
                      children: [
                        Input(
                          label: "Matricule/Mecano/Téléphone",
                          indication: "Matricule/Mecano/Téléphone",
                        ),
                        Input(
                          label: "Mot de passe",
                          indication: "Votre mot de passe",
                        ),

                        SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text("Se connecter"),
                          ),
                        ),
                        SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(child: Divider(thickness: 0.5)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Voir nos page avec"),
                            ),
                            Expanded(child: Divider(thickness: 0.5)),
                          ],
                        ),
                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Carre(chemin: 'assets/images/Facebook.png'),
                            SizedBox(width: 10),
                            Carre(chemin: 'assets/images/tiktok.png'),
                          ],
                        ),
                        SizedBox(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Mot de passe oublié?"),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                "Réinitialisez",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
