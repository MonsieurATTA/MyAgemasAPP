import 'package:flutter/material.dart';
import 'package:myagemas/Pages/home/Home.dart';
import 'package:myagemas/Pages/home/widgets/Carre.dart';
import 'package:myagemas/Pages/home/widgets/Input.dart';
import 'package:myagemas/moka_config.dart';
import 'package:myagemas/serviceapi.dart';
import 'package:url_launcher/url_launcher.dart';

class Verifiemotdepass extends StatefulWidget {
  final String numero;
  final bool isFirstConnection;

  const Verifiemotdepass({
    super.key,
    required this.numero,
    this.isFirstConnection = false,
  });

  @override
  State<Verifiemotdepass> createState() => _VerifiemotdepassState();
}

class _VerifiemotdepassState extends State<Verifiemotdepass> {
  final _formKey = GlobalKey<FormState>();
  final _motDePasseController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _motDePasseController.dispose();
    super.dispose();
  }

  Future<void> _verifierMotDePasse() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final motDePasse = _motDePasseController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Cette page est uniquement pour les clients déjà connectés (statut = 2)
      // Vérifier le mot de passe
      final clientData = await connexionClient(widget.numero, motDePasse);

      if (!mounted) return;

      if (clientData == null) {
        setState(() {
          _errorMessage = 'Mot de passe incorrect';
          _isLoading = false;
        });
      } else {
        // Connexion réussie - sauvegarder l'IDCclient_agemas comme ID global
        if (clientData.idCclientAgemas != null) {
          await setDefaultMokaClientId(clientData.idCclientAgemas.toString());
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
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
            child: Image.asset(
              'assets/images/icon.png', // ton image
              fit: BoxFit.fill,
            ),
          ),

          /// 🔹 Overlay sombre
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          /// 🔹 Contenu principal
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
                    Text("Entrez votre mot de passe"),

                    SizedBox(height: 25),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Input(
                            label: "Mot de passe",
                            indication: "Votre mot de passe",
                            controller: _motDePasseController,
                            obscureText: true,
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
                              onPressed: _isLoading
                                  ? null
                                  : _verifierMotDePasse,
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
                                  : Text("Se connecter"),
                            ),
                          ),

                          SizedBox(height: 20),

                          /// 🔹 Séparateur
                          Row(
                            children: [
                              Expanded(child: Divider(thickness: 0.5)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("Voir nos pages"),
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
