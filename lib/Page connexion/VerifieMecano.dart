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
            builder: (context) =>
                Verifiemotdepass(numero: numero, isFirstConnection: false),
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
      body: Stack(
        children: [
          /// 🔹 Image de fond
          Positioned.fill(
            child: Image.asset('assets/images/icon.png', fit: BoxFit.fill),
          ),

          /// 🔹 Overlay sombre (lisibilité)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          /// 🔹 Contenu
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.93),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Connexion",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Bienvenue sur votre application MY-AGEMAS"),

                    SizedBox(height: 25),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Input(
                            label: "Entrer le numéro de votre Agemas",
                            indication: "Ex: M3-00000",
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

                          SizedBox(height: 25),

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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text("Vérifier"),
                            ),
                          ),

                          SizedBox(height: 20),

                          /// 🔹 Séparateur
                          Row(
                            children: [
                              Expanded(child: Divider(thickness: 0.5)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("Voir nos pages sur"),
                              ),
                              Expanded(child: Divider(thickness: 0.5)),
                            ],
                          ),

                          SizedBox(height: 12),

                          /// 🔹 Boutons réseaux sociaux
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Carre(
                                chemin: 'assets/images/Facebook.png',
                                onTap: () async {
                                  final url = Uri.parse(
                                    "https://www.facebook.com/share/1FrRTmvVPX/?mibextid=wwXIfr",
                                  );
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                              ),
                              SizedBox(width: 12),
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

                          SizedBox(height: 10),

                          /// 🔹 Mot de passe oublié
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Mot de passe oublié ? "),
                              GestureDetector(
                                onTap: () {
                                  // TODO: navigation reset mdp
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
        ],
      ),
    );
  }
}
