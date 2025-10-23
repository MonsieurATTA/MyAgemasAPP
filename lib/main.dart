import 'package:flutter/material.dart';
import 'commune.dart';
import 'pharmcie2.dart';
import 'serviceapi.dart';

void main() {
  runApp(const PharmaciesApp());
}

class PharmaciesApp extends StatelessWidget {
  const PharmaciesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharmacies par commune',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const CommuneListPage(),
    );
  }
}

class CommuneListPage extends StatefulWidget {
  const CommuneListPage({super.key});

  @override
  State<CommuneListPage> createState() => _CommuneListPageState();
}

// État de la page listant les communes
class _CommuneListPageState extends State<CommuneListPage> {
  bool _isLoading = false; // Est-ce que l'app charge des données ?
  String? _error; // Y a-t-il une erreur ?
  List<Commune> _communes = <Commune>[]; // Liste des communes

  // Dès l'initialisation du State, on charge les communes
  @override
  void initState() {
    super.initState();
    _loadCommunes(); //Dès que la page s'ouvre, cette fonction se déclenche automatiquement et dit "Va chercher la liste des communes !"
  }

  //fonction qui va chercher les communes
  Future<void> _loadCommunes() async {
    setState(() {
      _isLoading = true; // Indique que le chargement est en cours
      _error = null; // Réinitialise le message d'erreur
    });
    try {
      final communes =
          await fetchCommunes(); // Appelle la fonction pour récupérer les communes
      communes.sort(
        (a, b) => a.commune.toLowerCase().compareTo(b.commune.toLowerCase()),
      ); // Trie les communes par ordre alphabétique
      setState(() {
        _communes = communes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Impossible de charger les communes: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Communes')),
      body:
          _isLoading // Si l'application est en train de charger les données
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: _loadCommunes,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              // Permet de rafraîchir la liste en tirant vers le bas
              onRefresh: _loadCommunes,
              child: ListView.separated(
                physics:
                    const AlwaysScrollableScrollPhysics(), // Permet de faire défiler même si la liste est courte
                itemCount: _communes.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final c =
                      _communes[index]; // Récupère la commune à l'index donné
                  return ListTile(
                    title: Text(c.commune.isEmpty ? 'Commune' : c.commune),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        // Navigue vers la page des pharmacies de la commune sélectionnée
                        MaterialPageRoute(
                          builder: (_) => PharmacyByCommunePage(commune: c),
                        ),
                      ); // Lorsque l'utilisateur appuie sur une commune, il est redirigé vers une nouvelle page affichant les pharmacies de cette commune
                    },
                  );
                },
              ),
            ),
    );
  }
}

class PharmacyByCommunePage extends StatefulWidget {
  final Commune commune;
  const PharmacyByCommunePage({super.key, required this.commune});

  @override
  State<PharmacyByCommunePage> createState() => _PharmacyByCommunePageState();
}

class _PharmacyByCommunePageState extends State<PharmacyByCommunePage> {
  bool _isLoading = false;
  String? _error;
  List<Pharmacy> _pharmacies = <Pharmacy>[];

  @override
  void initState() {
    super.initState();
    _loadPharmacies();
  }

  Future<void> _loadPharmacies() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await fetchPharmaciesByCommune(widget.commune.id);
      setState(() {
        _pharmacies = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Impossible de charger les pharmacies: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pharmacies • ${widget.commune.commune}')),
      body:
          _isLoading // Si l'application est en train de charger les données
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed:
                          _loadPharmacies, // Bouton pour réessayer de charger les pharmacies
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            )
          : _pharmacies
                .isEmpty // Si la liste des pharmacies est vide
          ? const Center(child: Text('Aucune pharmacie trouvée'))
          : RefreshIndicator(
              onRefresh: _loadPharmacies,
              child: ListView.separated(
                physics:
                    const AlwaysScrollableScrollPhysics(), // Permet de faire défiler même si la liste est courte
                itemCount: _pharmacies.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final ph = _pharmacies[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.local_pharmacy,
                      color: Colors.blue,
                    ),
                    title: Text(ph.nomphar.isEmpty ? 'Pharmacie' : ph.nomphar),
                    subtitle: Text(
                      [
                        ph.situationgeo,
                        ph.telphar, //
                      ].where((e) => e.trim().isNotEmpty).join(' • '),
                    ),
                  );
                },
              ),
            ),
    );
  }
}




/* import 'package:flutter/material.dart';
import 'serviceAPI.dart';
import 'pharmcie2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pharmacies",
      theme: ThemeData(primarySwatch: Colors.green),
      home: const PharmaciesPage(),
    );
  }
}

class PharmaciesPage extends StatefulWidget {
  const PharmaciesPage({super.key});

  @override
  State<PharmaciesPage> createState() => _PharmaciesPageState();
}

class _PharmaciesPageState extends State<PharmaciesPage> {
  late Future<List<Pharmacy>> pharmacies;

  @override
  void initState() {
    super.initState();
    pharmacies = fetchPharmacies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des pharmacies")),
      body: FutureBuilder<List<Pharmacy>>(
        future: pharmacies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune pharmacie trouvée"));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final pharmacie = data[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.local_hospital,
                      color: Colors.green,
                    ),
                    title: Text(pharmacie.nomphar),
                    subtitle: Text((pharmacie.situationgeo)),
                    trailing: Text(pharmacie.telphar),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
 */