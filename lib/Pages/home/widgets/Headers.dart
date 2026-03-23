import 'package:flutter/material.dart';
import 'package:myagemas/moka_config.dart';
import 'package:myagemas/serviceapi.dart';

// Objectif : afficher le titre + la photo du client connecté.
class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  static const double _avatarRadius = 24;
  static const String _baseUrl = 'http://apimoka.agemas96.com';

  late final Future<String?> _photoUrlFuture = _loadPhotoUrl();

  Future<String?> _loadPhotoUrl() async {
    final clientId = (await getDefaultMokaClientId()).trim();
    if (clientId.isEmpty) return null;

    final adherents = await fetchAdherentsByClient(clientId);
    if (adherents.isEmpty) return null;

    final url = adherents.first.lienPhoto.trim();
    if (url.isEmpty) return null;
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    // Si l'API renvoie une URL relative, on la complète.
    final normalized = url.startsWith('/') ? url.substring(1) : url;
    return '$_baseUrl/$normalized';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top, // éviter le chevauchement
        left: 25,
        right: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Bienvenue,',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Chez AGEMAS ASSURANCE',
                style: TextStyle(fontSize: 19, color: Colors.white),
              ),
            ],
          ),
          FutureBuilder<String?>(
            future: _photoUrlFuture,
            builder: (context, snapshot) {
              final photoUrl = snapshot.data;

              final fallback = Image.asset(
                'assets/images/user.jpeg',
                width: _avatarRadius * 2,
                height: _avatarRadius * 2,
                fit: BoxFit.cover,
              );

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircleAvatar(
                  radius: _avatarRadius,
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }

              if (photoUrl == null || photoUrl.isEmpty) {
                return CircleAvatar(radius: _avatarRadius, child: fallback);
              }

              return CircleAvatar(
                radius: _avatarRadius,
                child: ClipOval(
                  child: Image.network(
                    photoUrl,
                    width: _avatarRadius * 2,
                    height: _avatarRadius * 2,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => fallback,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
