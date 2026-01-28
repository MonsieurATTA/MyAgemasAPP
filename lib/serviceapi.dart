import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'client_data.dart';
import 'commune.dart';
import 'moka_models.dart';
import 'pharmacie.dart';

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

Future<List<Adherent>> fetchAdherentsByClient(String clientId) async {
  final trimmed = clientId.trim();
  if (trimmed.isEmpty) {
    return [];
  }
  final uri = Uri.parse(
    '$_baseUrl/contrats/moka/client/${Uri.encodeComponent(trimmed)}',
  );
  return _fetchMokaList(uri, (json) => Adherent.fromJson(json));
}

Future<List<Beneficiaire>> fetchBeneficiairesByAdherent(
  String adherentId,
) async {
  final trimmed = adherentId.trim();
  if (trimmed.isEmpty) {
    return [];
  }
  final uri = Uri.parse(
    '$_baseUrl/beneficiaires/contrat/moka/client/${Uri.encodeComponent(trimmed)}',
  );
  return _fetchMokaList(uri, (json) => Beneficiaire.fromJson(json));
}

Future<List<T>> _fetchMokaList<T>(
  Uri uri,
  T Function(Map<String, dynamic>) mapper,
) async {
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
    final list = _normalizeDecoded(decoded);
    return list
        .where((e) => e is Map)
        .map((e) => mapper(Map<String, dynamic>.from(e as Map)))
        .toList();
  } finally {
    httpClient.close(force: true);
  }
}

List<dynamic> _normalizeDecoded(dynamic decoded) {
  if (decoded is List) {
    return decoded;
  }
  if (decoded is Map<String, dynamic>) {
    final data = decoded['data'];
    if (data is List) {
      return data;
    }
    final items = decoded['items'];
    if (items is List) {
      return items;
    }
    return [decoded];
  }
  return <dynamic>[];
}

// Fonction helper pour les requêtes POST
/* Future<dynamic> _postMokaRequest(Uri uri, Map<String, dynamic> body) async {
  final httpClient = HttpClient();
  try {
    final request = await httpClient.postUrl(uri);
    request.headers.set(
      HttpHeaders.contentTypeHeader,
      'application/x-www-form-urlencoded',
    );
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');

    // Encoder les paramètres comme form-urlencoded
    final params = body.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}',
        )
        .join('&');
    request.write(params);

    final response = await request.close();
    final responseBody = await utf8.decoder.bind(response).join();

    /* if (response.statusCode != 200) {
      throw HttpException('Status ${response.statusCode}: $responseBody');
    } */

    return jsonDecode(responseBody);
  } finally {
    httpClient.close(force: true);
  }
} */

Future<dynamic> _postMokaRequest(Uri uri, Map<String, dynamic> body) async {
  final httpClient = HttpClient()
    ..connectionTimeout = const Duration(seconds: 10);

  try {
    final request = await httpClient.postUrl(uri);

    final jsonBody = jsonEncode(body);
    final bytes = utf8.encode(jsonBody);

    request.headers.set(
      HttpHeaders.contentTypeHeader,
      'application/json; charset=utf-8',
    );
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');

    request.contentLength = bytes.length; // 🔥 évite le chunked
    request.add(bytes);

    final response = await request.close();
    final responseBody = await utf8.decoder.bind(response).join();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Erreur ${response.statusCode}: $responseBody',
        uri: uri,
      );
    }

    return responseBody.isEmpty ? null : jsonDecode(responseBody);
  } finally {
    httpClient.close(force: true);
  }
}

// Fonction helper pour les requêtes PUT
Future<dynamic> _putMokaRequest(Uri uri, Map<String, dynamic> body) async {
  final httpClient = HttpClient();
  try {
    final request = await httpClient.openUrl('PUT', uri);

    final jsonBody = jsonEncode(body);
    final bytes = utf8.encode(jsonBody);

    request.headers.set(
      HttpHeaders.contentTypeHeader,
      'application/json; charset=UTF-8',
    );
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    request.headers.set(HttpHeaders.contentLengthHeader, bytes.length);

    request.add(bytes);

    final response = await request.close();
    final responseBody = await utf8.decoder.bind(response).join();

    if (response.statusCode != 200) {
      throw HttpException('Status ${response.statusCode}: $responseBody');
    }

    return jsonDecode(responseBody);
  } finally {
    httpClient.close(force: true);
  }
}

/// Vérifie si c'est la première connexion du client
/// Retourne 0 si client n'existe pas, 1 si première connexion, 2 si déjà connecté
Future<int> verifierPremiereConnexion(String numero) async {
  final trimmed = numero.trim();
  if (trimmed.isEmpty) {
    throw ArgumentError('Le numéro ne peut pas être vide');
  }

  final uri = Uri.parse('$_baseUrl/verifie/premiere/connexion/client');
  final body = {'numero_police_matricule_mecano_cellulaire': trimmed};

  final response = await _postMokaRequest(uri, body);

  // La réponse peut être un nombre ou un objet avec le nombre
  if (response is int) {
    return response;
  } else if (response is Map && response['response'] != null) {
    return response['response'] is int
        ? response['response'] as int
        : int.tryParse(response['response'].toString()) ?? 0;
  } else if (response is num) {
    return response.toInt();
  }

  return int.tryParse(response.toString()) ?? 0;
}

/// Crée un mot de passe pour un client lors de sa première connexion
/// Retourne 1 si succès, 0 si client non trouvé
Future<int> creerMotDePasse(String numero, String motDePasse) async {
  final trimmedNumero = numero.trim();
  final trimmedPassword = motDePasse.trim();

  if (trimmedNumero.isEmpty) {
    throw ArgumentError('Le numéro ne peut pas être vide');
  }
  if (trimmedPassword.isEmpty) {
    throw ArgumentError('Le mot de passe ne peut pas être vide');
  }

  final uri = Uri.parse('$_baseUrl/creation/motdepasse/client');
  final body = {
    'numero_cellulaire': trimmedNumero,
    'mot_de_passe': trimmedPassword,
  };

  final response = await _putMokaRequest(uri, body);

  // La réponse peut être un nombre ou un objet avec le nombre
  if (response is int) {
    return response;
  } else if (response is Map && response['response'] != null) {
    return response['response'] is int
        ? response['response'] as int
        : int.tryParse(response['response'].toString()) ?? 0;
  } else if (response is num) {
    return response.toInt();
  }

  return int.tryParse(response.toString()) ?? 0;
}

/// Connecte un client avec son numéro et mot de passe
/// Retourne ClientData si succès, null si échec (réponse 0)
Future<ClientData?> connexionClient(String numero, String motDePasse) async {
  final trimmedNumero = numero.trim();
  final trimmedPassword = motDePasse.trim();

  if (trimmedNumero.isEmpty) {
    throw ArgumentError('Le numéro ne peut pas être vide');
  }
  if (trimmedPassword.isEmpty) {
    throw ArgumentError('Le mot de passe ne peut pas être vide');
  }

  final uri = Uri.parse('$_baseUrl/connexion/client');
  final body = {
    'numero_police_matricule_mecano_cellulaire': trimmedNumero,
    'mot_de_passe': trimmedPassword,
  };

  final response = await _postMokaRequest(uri, body);

  // Si la réponse est 0, la connexion a échoué
  if (response == 0 || (response is Map && response['response'] == 0)) {
    return null;
  }

  // Si c'est un objet Map, on crée un ClientData
  if (response is Map<String, dynamic>) {
    return ClientData.fromJson(response);
  }

  // Si c'est un objet avec des données client
  if (response is Map && response.containsKey('IDCclient_agemas')) {
    return ClientData.fromJson(Map<String, dynamic>.from(response));
  }

  return null;
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
