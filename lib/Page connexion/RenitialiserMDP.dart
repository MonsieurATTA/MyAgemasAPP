import 'package:flutter/material.dart';
import 'package:myagemas/Pages/home/widgets/Carre.dart';
import 'package:myagemas/Pages/home/widgets/Input.dart';

class Renitialisermdp extends StatefulWidget {
  const Renitialisermdp({super.key});

  @override
  State<Renitialisermdp> createState() => _RenitialisermdpState();
}

class _RenitialisermdpState extends State<Renitialisermdp> {
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
                    "Réinitialisation de mot de passe",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Après avoir réinitialiser vous recevrez un sms pour votre nouveau Mot de pass",
                  ),

                  SizedBox(height: 25),

                  SizedBox(height: 30),
                  Form(
                    child: Column(
                      children: [
                        Input(
                          label: "Nouveau",
                          indication: "Entrez un nouveau mot de passe",
                        ),
                        Input(
                          label: "Confirmer",
                          indication: "Entrez un nouveau mot de passe",
                        ),
                        Input(
                          label: "Téléphone",
                          indication: "Saisissez votre numéro de téléphone",
                        ),

                        SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text("Réinitialiser"),
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

                        /*  Row(
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
                        ), */
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
