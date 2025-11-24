class Adherent {
  Adherent({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.nomComplet,
    required this.numeroContrat,
    required this.produit,
    required this.statut,
    required this.dateEffet,
    required this.dateNaissance,
    required this.lieuNaissance,
    required this.email,
    required this.telephone,
    required this.cellulaire,
    required this.cumulCotise,
    required this.cotisationAdherent,
    required this.police,
    required this.raw,
  });

  final String id;
  final String nom;
  final String prenom;
  final String nomComplet;
  final String numeroContrat;
  final String produit;
  final String statut;
  final String dateEffet;
  final String dateNaissance;
  final String lieuNaissance;
  final String email;
  final String telephone;
  final String cellulaire;
  final String cumulCotise;
  final String cotisationAdherent;
  final String police;
  final Map<String, dynamic> raw;

  factory Adherent.fromJson(Map<String, dynamic> json) {
    final lastName = _pickString(json, const [
      'nom',
      'nomadherent',
      'nom_adherent',
      'nomadh',
      'lastname',
      'last_name',
    ]);
    final firstName = _pickString(json, const [
      'prenom',
      'prenoms',
      'prenomadherent',
      'prenadherent',
      'prenom_adherent',
      'prenom_adh',
      'firstname',
      'first_name',
    ]);
    final fullName = _pickString(json, const [
      'nomprenom',
      'nom_prenom',
      'nom_complet',
      'name',
      'fullname',
      'full_name',
      'designation',
    ]);

    return Adherent(
      id:
          _pickString(json, const [
            'idadherent',
            'id_adherent',
            'idadh',
            'id',
            'idcontrat',
            'id_contrat',
            'contrat_id',
          ]) ??
          '',
      nom: lastName ?? '',
      prenom: firstName ?? '',
      nomComplet: _concatName(fullName, firstName, lastName),
      numeroContrat:
          _pickString(json, const [
            'numcontrat',
            'numero_contrat',
            'contrat',
            'contrat_numero',
            'refcontrat',
            'ref_contrat',
            'numero',
            'numéro contrat',
          ]) ??
          '',
      produit:
          _pickString(json, const [
            'produit',
            'typecontrat',
            'formule',
            'formulecontrat',
            'garantie',
            'gamme',
          ]) ??
          '',
      statut:
          (_pickString(json, const ['statut', 'status', 'etat', 'situation']) ??
          ''),
      dateEffet:
          _pickString(json, const [
            'dateeffet',
            'date_effet',
            'date_debut',
            'datedebut',
            'debut',
            'effet',
          ]) ??
          '',
      dateNaissance:
          _pickString(json, const [
            'datenais',
            'datenaissance',
            'date_naissance',
            'datenaisadherent',
            'date_naiss',
          ]) ??
          '',
      lieuNaissance:
          _pickString(json, const [
            'lieunaissance',
            'lieu_naissance',
            'lieunais',
            'lieu_naiss',
          ]) ??
          '',
      email: _pickString(json, const ['email', 'mail', 'courriel']) ?? '',
      telephone:
          _pickString(json, const [
            'telephone',
            'tel',
            'portable',
            'gsm',
            'contact',
            'teladherent',
          ]) ??
          '',
      cellulaire:
          _pickString(json, const [
            'celadherent',
            'cel',
            'cellulaire',
            'portable',
            'gsm',
          ]) ??
          '',
      cumulCotise:
          _pickString(json, const [
            'cumulcotise',
            'cumul_cotise',
            'cumulcotisation',
            'cumul_cotisation',
            'cumul',
            'cotisation',
            'totcotise',
          ]) ??
          '',
      cotisationAdherent:
          _pickString(json, const [
            'cotisationadherent',
            'cotisation_adh',
            'cotisationadh',
            'cotisation',
            'cotis',
          ]) ??
          '',
      police:
          _pickString(json, const [
            'police',
            'numero_police',
            'num_police',
            'numeropolice',
            'refpolice',
          ]) ??
          '',
      raw: Map<String, dynamic>.from(json),
    );
  }

  List<MapEntry<String, String>> get details => [
    if (nom.isNotEmpty) MapEntry('Nom', nom),
    if (prenom.isNotEmpty) MapEntry('Prénom', prenom),
    if (produit.isNotEmpty) MapEntry('Produit', produit),
    if (statut.isNotEmpty) MapEntry('Statut', statut),
    if (dateEffet.isNotEmpty) MapEntry("Date d'effet", dateEffet),
    if (dateNaissance.isNotEmpty) MapEntry('Date de naissance', dateNaissance),
    if (lieuNaissance.isNotEmpty) MapEntry('Lieu de naissance', lieuNaissance),
    if (email.isNotEmpty) MapEntry('Email', email),
    if (telephone.isNotEmpty) MapEntry('Téléphone', telephone),
    if (cellulaire.isNotEmpty) MapEntry('Cel', cellulaire),
    if (cumulCotise.isNotEmpty) MapEntry('Cumul cotisé', cumulCotise),
    if (cotisationAdherent.isNotEmpty)
      MapEntry('Cotisation adhérent', cotisationAdherent),
    if (police.isNotEmpty) MapEntry('Police', police),
  ];
}

class Beneficiaire {
  Beneficiaire({
    required this.id,
    required this.code,
    required this.nom,
    required this.prenom,
    required this.nomComplet,
    required this.dateNaissance,
    required this.cellulairebene,
    required this.statutbene,
    required this.raw,
  });

  final String id;
  final String code;
  final String nom;
  final String prenom;
  final String nomComplet;
  final String dateNaissance;
  final String cellulairebene;
  final String statutbene;
  final Map<String, dynamic> raw;

  factory Beneficiaire.fromJson(Map<String, dynamic> json) {
    final lastName = _pickString(json, const [
      'nom',
      'nombeneficiaire',
      'nom_beneficiaire',
      'nombene',
      'nom_bene',
      'lastname',
    ]);
    final firstName = _pickString(json, const [
      'prenom',
      'prenombeneficiaire',
      'prenom_beneficiaire',
      'prenombene',
      'prenom_bene',
      'firstname',
    ]);
    final fullName = _pickString(json, const [
      'nomprenom',
      'nom_prenom',
      'nom_complet',
      'name',
      'fullname',
    ]);

    return Beneficiaire(
      id:
          _pickString(json, const [
            'idbeneficiaire',
            'id_beneficiaire',
            'idbenef',
            'id',
            'idadherent',
          ]) ??
          '',
      code:
          _pickString(json, const [
            'codebeneficiaire',
            'code_beneficiaire',
            'codebene',
            'code',
          ]) ??
          '',
      nom: lastName ?? '',
      prenom: firstName ?? '',
      nomComplet: _concatName(fullName, firstName, lastName),
      dateNaissance:
          _pickString(json, const [
            'datenaissance',
            'date_naissance',
            'dob',
            'birthday',
            'datenaissbene',
            'datenaiss_bene',
          ]) ??
          '',
      cellulairebene:
          _pickString(json, const [
            'cellulairebene',
            'cellulaire',
            'cellulair_benefiniciaire',
            'gsm',
            'contact',
            'telbeneficiaire',
          ]) ??
          '',
      statutbene:
          _pickString(json, const ['statutbene', 'status', 'etat']) ?? '',
      raw: Map<String, dynamic>.from(json),
    );
  }
}

String _concatName(String? fullName, String? firstName, String? lastName) {
  if (fullName != null && fullName.isNotEmpty) {
    return fullName;
  }
  final buffer = StringBuffer();
  if (firstName != null && firstName.isNotEmpty) {
    buffer.write(firstName);
  }
  if (lastName != null && lastName.isNotEmpty) {
    if (buffer.isNotEmpty) buffer.write(' ');
    buffer.write(lastName);
  }
  return buffer.isEmpty ? '' : buffer.toString();
}

String? _pickString(Map<String, dynamic> json, List<String> keys) {
  if (json.isEmpty) return null;
  final normalized = json.map(
    (key, value) => MapEntry(key.toLowerCase(), value),
  );
  for (final candidate in keys) {
    final value = normalized[candidate.toLowerCase()];
    if (value == null) {
      continue;
    }
    final str = value.toString().trim();
    if (str.isNotEmpty && str.toLowerCase() != 'null') {
      return str;
    }
  }
  return null;
}
