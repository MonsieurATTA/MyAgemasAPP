import 'package:shared_preferences/shared_preferences.dart';

/// Identifiant client Moka utilisé pour précharger la page.
/// Cette valeur est stockée de manière persistante et mise à jour automatiquement lors de la connexion.
Future<String> getDefaultMokaClientId() async {
  final prefs = await SharedPreferences.getInstance();
  // Valeur par défaut pour les tests si aucun ID n'est sauvegardé
  return prefs.getString('defaultMokaClientId') ?? '';
}

/// Définit l'identifiant client Moka de manière persistante.
Future<void> setDefaultMokaClientId(String clientId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('defaultMokaClientId', clientId);
}

/// Pour la compatibilité avec le code existant, on garde une variable mais elle sera obsolète
@Deprecated('Utilisez getDefaultMokaClientId() à la place')
String get defaultMokaClientId => '';
