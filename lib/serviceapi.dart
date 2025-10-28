import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'commune.dart';
import 'pharmcie2.dart';

final _baseUrl = 'http://apimoka.agemas96.com';

// Récupère toutes les pharmacies
Future<List<Pharmacy>> fetchAllPharmacies() async {
  final uri = Uri.parse('$_baseUrl/pharmacies');
  final httpClient =
      HttpClient(); // Crée un client HTTP(comme le navigateur) qui va envoyer la requête à ton serveur.
  try {
    final request = await httpClient.getUrl(
      uri,
    ); // Crée une requête GET pour l'URI spécifiée.
    request.headers.set(
      HttpHeaders.acceptHeader,
      'application/json',
    ); // Indique que l'on attend une réponse au format JSON.
    final response = await request
        .close(); // Envoie la requête et attend la réponse du serveur.
    if (response.statusCode != 200) {
      throw HttpException('Status ${response.statusCode}');
    }
    final body = await utf8.decoder
        .bind(response)
        .join(); // Lit le corps de la réponse en tant que chaîne UTF-8.
    final decoded = jsonDecode(
      body,
    ); // Décode la chaîne JSON en une structure de données Dart.

    // Gère les différents formats de réponse possibles
    List list;
    if (decoded is List) {
      list = decoded;
    } else if (decoded is Map && decoded['data'] is List) {
      list = decoded['data'] as List;
    } else {
      return [];
    }
    // Convertir en liste de Pharmacy
    //on crée un objet Pharmacy grâce à la méthode fromJson() (définie dans pharmcie2.dart).
    return list
        .map<Pharmacy>((e) => Pharmacy.fromJson(e as Map<String, dynamic>))
        .toList();
  } finally {
    httpClient.close(force: true);
  }
}

// Récupère toutes les communes
Future<List<Commune>> fetchCommunes() async {
  final uri = Uri.parse('$_baseUrl/communes');
  final httpClient = HttpClient();
  try {
    final request = await httpClient.getUrl(uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    final response = await request.close();
    if (response.statusCode != 200) {
      throw HttpException('Status ${response.statusCode}');
    }

    final body = await utf8.decoder.bind(response).join();
    final decoded = jsonDecode(body);
    if (decoded is List) {
      return decoded
          .map<Commune>((e) => Commune.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (decoded is Map && decoded['data'] is List) {
      return (decoded['data'] as List)
          .map<Commune>((e) => Commune.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  } finally {
    httpClient.close(force: true);
  }
}

// Récupère les pharmacies d'une commune donnée
// Essayer les deux formats d'URI possibles
Future<List<Pharmacy>> fetchPharmaciesByCommune(int idCommune) async {
  final candidateUris = <Uri>[
    Uri.parse('$_baseUrl/pharmacies?idcom=$idCommune'),
    Uri.parse('$_baseUrl/pharmacies/$idCommune'),
  ];
  final httpClient = HttpClient();
  try {
    for (final uri in candidateUris) {
      // Le programme teste chaque lien jusqu’à ce que l’un fonctionne.
      try {
        final request = await httpClient.getUrl(uri);
        request.headers.set(HttpHeaders.acceptHeader, 'application/json');
        final response = await request.close();
        if (response.statusCode != 200) {
          continue;
        }
        final body = await utf8.decoder.bind(response).join();
        final decoded = jsonDecode(body);
        List list;
        if (decoded is List) {
          list = decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          list = decoded['data'] as List;
        } else {
          continue;
        }
        // Filtrer côté client par id de commune car l'API peut renvoyer tout
        final filtered = list.where((e) {
          if (e is Map<String, dynamic>) {
            final dynamic raw =
                e['Idcommune'] ??
                e['idcommune'] ??
                e['id_commune'] ??
                e['idcom'];
            final int id = (raw is String)
                ? int.tryParse(raw) ?? -1
                : (raw is int ? raw : -1);
            return id == idCommune;
          }
          return false;
        }).toList();

        return filtered
            .map<Pharmacy>((e) => Pharmacy.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        // Essayer l'URI suivant
        continue;
      }
    }
    return [];
  } finally {
    httpClient.close(force: true);
  }
}

/* import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pharmcie2.dart';

Future<List<Pharmacy>> fetchPharmacies() async {
  final response = await http.get(
    Uri.parse("http://apimoka.agemas96.com/pharmacies"),
  );

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    return data.map((json) => Pharmacy.fromJson(json)).toList();
  } else {
    throw Exception("Erreur de chargement (${response.statusCode})");
  }
} */
