import 'package:flutter/material.dart';
import 'package:myagemas/commune.dart';
import 'package:myagemas/pharmacie.dart';
import 'package:myagemas/serviceapi.dart';

class Recherche extends StatefulWidget {
  const Recherche({super.key});

  @override
  State<Recherche> createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  final TextEditingController _controller = TextEditingController();
  List<Pharmacy> _pharmacies = [];
  List<Commune> _communes = [];
  int? _communeFilterId;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    _loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        fetchAllPharmacies(),
        fetchCommunes(),
      ]);
      final communes = results[1] as List<Commune>;
      communes.sort(
        (a, b) => a.commune.toLowerCase().compareTo(b.commune.toLowerCase()),
      );
      if (!mounted) return;
      setState(() {
        _pharmacies = results[0] as List<Pharmacy>;
        _communes = communes;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Impossible de charger les pharmacies';
        _isLoading = false;
      });
    }
  }

  String _communeName(int idCommune) {
    for (final c in _communes) {
      if (c.id == idCommune) return c.commune;
    }
    return '';
  }

  List<Pharmacy> get _filteredPharmacies {
    final query = _controller.text.trim().toLowerCase();
    final hasQuery = query.length >= 2;
    final hasCommuneFilter = _communeFilterId != null;

    if (!hasQuery && !hasCommuneFilter) return [];

    return _pharmacies.where((p) {
      if (hasCommuneFilter && p.idcommune != _communeFilterId) {
        return false;
      }
      if (!hasQuery) return true;

      final commune = _communeName(p.idcommune).toLowerCase();
      return p.nomphar.toLowerCase().contains(query) ||
          p.situationgeo.toLowerCase().contains(query) ||
          p.telphar.contains(query) ||
          commune.contains(query);
    }).toList()
      ..sort((a, b) => a.nomphar.toLowerCase().compareTo(b.nomphar.toLowerCase()));
  }

  String? get _selectedCommuneLabel {
    if (_communeFilterId == null) return null;
    return _communeName(_communeFilterId!);
  }

  Future<void> _showCommuneFilter() async {
    final selected = await showModalBottomSheet<int?>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Filtrer par commune',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.clear_all),
                title: const Text('Toutes les communes'),
                selected: _communeFilterId == null,
                onTap: () => Navigator.pop(context, null),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _communes.length,
                  itemBuilder: (context, index) {
                    final commune = _communes[index];
                    return ListTile(
                      title: Text(commune.commune),
                      selected: _communeFilterId == commune.id,
                      onTap: () => Navigator.pop(context, commune.id),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != _communeFilterId && mounted) {
      setState(() => _communeFilterId = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredPharmacies;
    final showResults =
        !_isLoading && _error == null && (results.isNotEmpty || _hasActiveSearch);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              hintText: 'Rechercher votre pharmacie',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Filtrer par commune',
                    onPressed: _isLoading ? null : _showCommuneFilter,
                    icon: Icon(
                      Icons.filter_list,
                      color: _communeFilterId != null
                          ? const Color.fromARGB(255, 47, 159, 229)
                          : Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 47, 159, 229),
                      ),
                      child: const Icon(
                        Icons.mic_none_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_communeFilterId != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: InputChip(
                label: Text(_selectedCommuneLabel ?? 'Commune'),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => setState(() => _communeFilterId = null),
                backgroundColor: Colors.white,
              ),
            ),
          ],
          if (_isLoading) ...[
            const SizedBox(height: 16),
            const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
            TextButton(onPressed: _loadData, child: const Text('Réessayer')),
          ],
          if (showResults) ...[
            const SizedBox(height: 12),
            if (results.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Aucune pharmacie trouvée',
                  textAlign: TextAlign.center,
                ),
              )
            else
              Container(
                constraints: const BoxConstraints(maxHeight: 280),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final ph = results[index];
                    final commune = _communeName(ph.idcommune);
                    return ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.local_pharmacy,
                        color: Colors.green,
                      ),
                      title: Text(
                        ph.nomphar.isEmpty ? 'Pharmacie' : ph.nomphar,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        [
                          if (commune.isNotEmpty) commune,
                          ph.situationgeo,
                          ph.telphar,
                        ].where((e) => e.trim().isNotEmpty).join(' • '),
                      ),
                    );
                  },
                ),
              ),
          ],
        ],
      ),
    );
  }

  bool get _hasActiveSearch {
    return _controller.text.trim().length >= 2 || _communeFilterId != null;
  }
}
