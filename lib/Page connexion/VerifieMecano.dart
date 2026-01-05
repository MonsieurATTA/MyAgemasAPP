import 'package:flutter/material.dart';
import 'package:myagemas/Pages/home/widgets/Carre.dart';
import 'package:myagemas/Pages/home/widgets/Input.dart';
import 'package:myagemas/Page%20connexion/VerifieMotdePass.dart';
import 'package:myagemas/Page%20connexion/CreationMotDePasse.dart';
import 'package:myagemas/serviceapi.dart';
import 'package:url_launcher/url_launcher.dart';

class Verifiemecano extends StatefulWidget {
  const Verifiemecano({super.key});

  @override
  State<Verifiemecano> createState() => _VerifieMecanoState();
}

class _VerifieMecanoState extends State<Verifiemecano> {
  final _formKey = GlobalKey<FormState>();
  final _numeroController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _numeroController.dispose();
    super.dispose();
  }

  Future<void> _verifierMecano() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final numero = _numeroController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Vérifier le statut de première connexion
      final statut = await verifierPremiereConnexion(numero);

      if (!mounted) return;

      if (statut == 0) {
        // Client n'existe pas
        setState(() {
          _errorMessage = 'Ce client n\'existe pas dans notre base de données';
          _isLoading = false;
        });
      } else if (statut == 1) {
        // Première connexion - rediriger vers la création de mot de passe
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreationMotDePasse(numero: numero),
          ),
        );
      } else if (statut == 2) {
        // Déjà connecté - rediriger vers la vérification du mot de passe
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Verifiemotdepass(numero: numero, isFirstConnection: false),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erreur lors de la vérification: $e';
        _isLoading = false;
      });
    }
  }

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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Connexion",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text("Bienvenue sur votre application MY-AGEMAS"),

                  SizedBox(height: 25),

                  SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Input(
                          label: "Matricule/Mecano/Téléphone",
                          indication: "Matricule/Mecano/Téléphone",
                          controller: _numeroController,
                        ),
                        if (_errorMessage != null) ...[
                          SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                            child: ElevatedButton(
                            onPressed: _isLoading ? null : _verifierMecano,
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text("Vérifier"),
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
                            Carre(
                              chemin: 'assets/images/Facebook.png',
                              onTap: () async {
                                final url = Uri.parse(
                                  "https://www.facebook.com/share/171Mcd8BCb/?mibextid=wwXIfr",
                                );
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                            ),
                            SizedBox(width: 10),
                            Carre(
                              chemin: 'assets/images/tiktok.png',
                              onTap: () async {
                                final url = Uri.parse(
                                  "https://www.tiktok.com/@agemas.assurance?_t=ZM-8xHHerJZ8rN&_r=1",
                                );
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Mot de passe oublié?"),
                            GestureDetector(
                              onTap: () {
                                /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Renitialisermdp(),
                                  ),
                                ); */
                              },
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
