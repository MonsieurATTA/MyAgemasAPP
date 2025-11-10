class Pharmacy {
  final int idphar;
  final int idcommune;
  final String nomphar;
  final String situationgeo;
  final String telphar;

  Pharmacy({
    required this.idphar,
    required this.idcommune,
    required this.nomphar,
    required this.situationgeo,
    required this.telphar,
  });

  /// Accepte différentes clés possibles depuis l'API
  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    final dynamic idValue =
        json['Idpharmacie'] ??
        json['idpharmacie'] ??
        json['id'] ??
        json['id_pharmacie'];
    final dynamic idComValue =
        json['Idcommune'] ??
        json['idcommune'] ??
        json['id_commune'] ??
        json['idcom'];
    final dynamic nameValue =
        json['nomphar'] ?? json['Nomphar'] ?? json['nom'] ?? json['name'];
    final dynamic addrValue =
        json['situationgeo'] ?? json['adresse'] ?? json['address'];
    final dynamic telValue =
        json['telphar'] ?? json['telephone'] ?? json['phone'];
    return Pharmacy(
      idphar: (idValue is String)
          ? int.tryParse(idValue) ?? 0
          : (idValue ?? 0) as int,
      idcommune: (idComValue is String)
          ? int.tryParse(idComValue) ?? 0
          : (idComValue ?? 0) as int,
      nomphar: (nameValue ?? '').toString(),
      situationgeo: (addrValue ?? '').toString(),
      telphar: (telValue ?? '').toString(),
    );
  }
}

/* class Pharmacy {
  final String nomphar;
  final String situationgeo;
  final String telphar;
  Pharmacy({
    required this.nomphar,
    required this.situationgeo,
    required this.telphar,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      nomphar: (json['nomphar'] as String?) ?? '',
      situationgeo: (json['situationgeo'] as String?) ?? '',
      telphar: (json['telphar'] as String?) ?? '',
    );
  }
} */
