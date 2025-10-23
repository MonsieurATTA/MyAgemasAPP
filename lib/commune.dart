class Commune {
  final int id;
  final String commune;

  Commune({required this.id, required this.commune});

  /// Accepte différentes clés possibles: id/idcom, commune/nom/name
  factory Commune.fromJson(Map<String, dynamic> json) {
    final dynamic idValue =
        json['id'] ?? json['idcom'] ?? json['id_commune'] ?? json['idcommune'];
    final dynamic nameValue = json['commune'] ?? json['nom'] ?? json['name'];
    return Commune(
      id: (idValue is String)
          ? int.tryParse(idValue) ?? 0
          : (idValue ?? 0) as int,
      commune: (nameValue ?? '').toString(),
    );
  }
}
