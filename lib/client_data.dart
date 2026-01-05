/// Modèle de données pour les informations client retournées par l'API de connexion
class ClientData {
  final int? idCclientAgemas;
  final int? civilite; // 1-Monsieur, 2-Madame, 3-Mademoiselle
  final int? situationMatrimoniale; // 1-Célibataire, 2-Marié(e), 3-En concubinage, 4-Divorcé(e), 5-Veuf(ve), 6-En concubinage
  final String? nom;
  final String? prenom;
  final DateTime? datenais;
  final String? lieunais;
  final String? corporation;
  final String? fonctionClient;
  final String? lieuService;
  final String? lieuResidenceFamille;
  final String? matriculemecano;
  final String? cellulaireClientAgemas;
  final String? adresseemail;
  final bool? compteActif;

  ClientData({
    this.idCclientAgemas,
    this.civilite,
    this.situationMatrimoniale,
    this.nom,
    this.prenom,
    this.datenais,
    this.lieunais,
    this.corporation,
    this.fonctionClient,
    this.lieuService,
    this.lieuResidenceFamille,
    this.matriculemecano,
    this.cellulaireClientAgemas,
    this.adresseemail,
    this.compteActif,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
      idCclientAgemas: json['IDCclient_agemas'] != null
          ? (json['IDCclient_agemas'] is int
              ? json['IDCclient_agemas'] as int
              : int.tryParse(json['IDCclient_agemas'].toString()))
          : null,
      civilite: json['civilite'] != null
          ? (json['civilite'] is int
              ? json['civilite'] as int
              : int.tryParse(json['civilite'].toString()))
          : null,
      situationMatrimoniale: json['situation_matrimoniale'] != null
          ? (json['situation_matrimoniale'] is int
              ? json['situation_matrimoniale'] as int
              : int.tryParse(json['situation_matrimoniale'].toString()))
          : null,
      nom: json['nom']?.toString(),
      prenom: json['prenom']?.toString(),
      datenais: json['datenais'] != null
          ? (json['datenais'] is DateTime
              ? json['datenais'] as DateTime
              : DateTime.tryParse(json['datenais'].toString()))
          : null,
      lieunais: json['lieunais']?.toString(),
      corporation: json['corporation']?.toString(),
      fonctionClient: json['fonction_client']?.toString(),
      lieuService: json['lieu_service']?.toString(),
      lieuResidenceFamille: json['lieu_residence_famille']?.toString(),
      matriculemecano: json['matriculemecano']?.toString(),
      cellulaireClientAgemas: json['Cellulaire_client_agemas']?.toString(),
      adresseemail: json['Adresseemail']?.toString(),
      compteActif: json['compte_actif'] is bool
          ? json['compte_actif'] as bool
          : json['compte_actif']?.toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IDCclient_agemas': idCclientAgemas,
      'civilite': civilite,
      'situation_matrimoniale': situationMatrimoniale,
      'nom': nom,
      'prenom': prenom,
      'datenais': datenais?.toIso8601String(),
      'lieunais': lieunais,
      'corporation': corporation,
      'fonction_client': fonctionClient,
      'lieu_service': lieuService,
      'lieu_residence_famille': lieuResidenceFamille,
      'matriculemecano': matriculemecano,
      'Cellulaire_client_agemas': cellulaireClientAgemas,
      'Adresseemail': adresseemail,
      'compte_actif': compteActif,
    };
  }
}

