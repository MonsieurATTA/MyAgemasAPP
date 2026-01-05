import 'package:flutter/material.dart';
import 'package:myagemas/Pages/home/Home.dart';
import 'package:myagemas/Pages/home/widgets/Carre.dart';
import 'package:myagemas/Pages/home/widgets/Input.dart';
import 'package:myagemas/moka_config.dart';
import 'package:myagemas/serviceapi.dart';
import 'package:url_launcher/url_launcher.dart';

class CreationMotDePasse extends StatefulWidget {
  final String numero;

  const CreationMotDePasse({super.key, required this.numero});

  @override
  State<CreationMotDePasse> createState() => _CreationMotDePasseState();
}

class _CreationMotDePasseState extends State<CreationMotDePasse> {
  final _formKey = GlobalKey<FormState>();
  final _telephoneController = TextEditingController();
  final _nouveauMotDePasseController = TextEditingController();
  final _confirmerMotDePasseController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _telephoneController.text = widget.numero;
  }

  @override
  void dispose() {
    _telephoneController.dispose();
    _nouveauMotDePasseController.dispose();
    _confirmerMotDePasseController.dispose();
    super.dispose();
  }

  Future<void> _creerMotDePasse() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nouveauMotDePasse = _nouveauMotDePasseController.text.trim();
    final confirmerMotDePasse = _confirmerMotDePasseController.text.trim();

    if (nouveauMotDePasse != confirmerMotDePasse) {
      setState(() {
        _errorMessage = 'Les mots de passe ne correspondent pas';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final numero = _telephoneController.text.trim();
      final result = await creerMotDePasse(numero, nouveauMotDePasse);

      if (!mounted) return;

      if (result == 1) {
        // Succès - se connecter pour obtenir l'IDCclient_agemas
        try {
          final clientData = await connexionClient(numero, nouveauMotDePasse);

          if (!mounted) return;

          if (clientData != null && clientData.idCclientAgemas != null) {
            // Sauvegarder l'IDCclient_agemas comme ID global
            await setDefaultMokaClientId(clientData.idCclientAgemas.toString());
          } else {
            // Si on n'obtient pas l'ID, utiliser le numéro temporairement
            await setDefaultMokaClientId(numero);
          }
        } catch (e) {
          // En cas d'erreur, utiliser le numéro temporairement
          await setDefaultMokaClientId(numero);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        setState(() {
          _errorMessage = 'Le client n\'a pas été trouvé';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erreur lors de la création du mot de passe: $e';
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Création de mot de passe",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Créez un mot de passe pour votre première connexion"),
                    SizedBox(height: 25),
                    SizedBox(height: 30),
                    Input(
                      label: "Téléphone",
                      indication: "Votre numéro de téléphone",
                      controller: _telephoneController,
                    ),
                    Input(
                      label: "Nouveau mot de passe",
                      indication: "Entrez un nouveau mot de passe",
                      controller: _nouveauMotDePasseController,
                      obscureText: true,
                    ),
                    Input(
                      label: "Confirmer mot de passe",
                      indication: "Confirmez votre mot de passe",
                      controller: _confirmerMotDePasseController,
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
                                style: TextStyle(color: Colors.red.shade900),
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
                        onPressed: _isLoading ? null : _creerMotDePasse,
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
                            : Text("Créer le mot de passe"),
                      ),
                    ),
                    SizedBox(height: 15),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
