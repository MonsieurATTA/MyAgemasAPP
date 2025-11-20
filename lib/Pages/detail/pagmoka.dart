import 'package:flutter/material.dart';
import 'package:myagemas/moka_config.dart';
import 'package:myagemas/moka_models.dart';
import 'package:myagemas/serviceapi.dart';

class PageadherentMOKA extends StatefulWidget {
  const PageadherentMOKA({super.key});

  @override
  State<PageadherentMOKA> createState() => _PageadherentMOKAState();
}

class _PageadherentMOKAState extends State<PageadherentMOKA> {
  late final String _clientId = defaultMokaClientId.trim();
  bool _isLoading = false;
  String? _errorMessage;
  List<Adherent> _adherents = <Adherent>[];

  final Map<String, List<Beneficiaire>> _beneficiairesByAdherent =
      <String, List<Beneficiaire>>{};
  final Map<String, bool> _beneficiairesLoading = <String, bool>{};
  final Map<String, String?> _beneficiairesError = <String, String?>{};

  @override
  void initState() {
    super.initState();
    _loadAdherents();
  }

  Future<void> _loadAdherents() async {
    if (_clientId.isEmpty) {
      setState(() {
        _errorMessage =
            "Aucun ID client n'est configuré. Modifiez defaultMokaClientId.";
        _adherents = <Adherent>[];
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _adherents = <Adherent>[];
      _beneficiairesByAdherent.clear();
      _beneficiairesLoading.clear();
      _beneficiairesError.clear();
    });
    try {
      final results = await fetchAdherentsByClient(_clientId);
      if (!mounted) return;
      setState(() {
        _adherents = results;
        if (results.isEmpty) {
          _errorMessage = "Aucun adhérent trouvé pour l'ID $_clientId.";
        }
      });
      _prefetchBeneficiaires(results);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erreur lors du chargement: $e';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _prefetchBeneficiaires(List<Adherent> adherents) {
    for (final adherent in adherents) {
      final id = adherent.id;
      if (id.isEmpty) continue;
      final alreadyLoaded = _beneficiairesByAdherent.containsKey(id);
      final isLoading = _beneficiairesLoading[id] ?? false;
      if (alreadyLoaded || isLoading) continue;
      _loadBeneficiaires(id);
    }
  }

  Future<void> _loadBeneficiaires(String adherentId) async {
    setState(() {
      _beneficiairesLoading[adherentId] = true;
      _beneficiairesError.remove(adherentId);
    });
    try {
      final results = await fetchBeneficiairesByAdherent(adherentId);
      if (!mounted) return;
      setState(() {
        _beneficiairesByAdherent[adherentId] = results;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _beneficiairesError[adherentId] = 'Erreur: $e';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _beneficiairesLoading[adherentId] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adhérents Moka'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _ClientHeader(
              clientId: _clientId,
              isLoading: _isLoading,
              onRefresh: _loadAdherents,
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: _ErrorBanner(message: _errorMessage!),
              ),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_adherents.isEmpty) {
      return Center(
        child: Text(
          "Aucun résultat pour l'identifiant $_clientId.\nVérifiez la valeur de `defaultMokaClientId`.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadAdherents,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _adherents.length,
        itemBuilder: (context, index) {
          final adherent = _adherents[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        child: Text(
                          _initials(adherent.nomComplet),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              adherent.nomComplet.isEmpty
                                  ? 'Adhérent ${adherent.id}'
                                  : adherent.nomComplet,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              adherent.numeroContrat.isNotEmpty
                                  ? 'Contrat ${adherent.numeroContrat}'
                                  : 'ID: ${adherent.id.isEmpty ? 'non renseigné' : adherent.id}',
                            ),
                          ],
                        ),
                      ),
                      if (adherent.statut.isNotEmpty)
                        _StatusChip(label: adherent.statut),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildAdherentDetails(adherent),
                  const SizedBox(height: 16),
                  Text(
                    'Bénéficiaires',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildBeneficiairesSection(adherent),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdherentDetails(Adherent adherent) {
    final details = adherent.details;
    if (details.isEmpty) {
      return Text(
        'Aucun détail supplémentaire fourni par le service.',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: details.map((entry) {
        final formattedValue = entry.key.toLowerCase().contains('date')
            ? _formatDate(entry.value)
            : entry.value;
        return _InfoChip(
          label: entry.key,
          value: formattedValue,
        );
      }).toList(),
    );
  }

  Widget _buildBeneficiairesSection(Adherent adherent) {
    if (adherent.id.isEmpty) {
      return Text(
        "Impossible de récupérer les bénéficiaires: l'ID adhérent est absent.",
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    }
    final loading = _beneficiairesLoading[adherent.id] ?? false;
    final error = _beneficiairesError[adherent.id];
    final beneficiaires = _beneficiairesByAdherent[adherent.id];
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: () => _loadBeneficiaires(adherent.id),
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
          ),
        ],
      );
    }
    if (beneficiaires == null) {
      return Text(
        'Chargement des bénéficiaires…',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    if (beneficiaires.isEmpty) {
      return Text(
        'Aucun bénéficiaire trouvé pour cet adhérent.',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Column(
      children: beneficiaires.map((benef) {
        final theme = Theme.of(context);
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.family_restroom_outlined),
          title: Text(
            benef.code.isEmpty ? 'Code bénéficiaire non renseigné' : 'Code: ${benef.code}',
            style: theme.textTheme.titleSmall,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (benef.nom.isNotEmpty) Text('Nom: ${benef.nom}'),
              if (benef.prenom.isNotEmpty) Text('Prénom: ${benef.prenom}'),
              if (benef.dateNaissance.isNotEmpty)
                Text('Date de naissance: ${_formatDate(benef.dateNaissance)}'),
              if (benef.relation.isNotEmpty) Text('Lien: ${benef.relation}'),
              if (benef.telephone.isNotEmpty) Text('Téléphone: ${benef.telephone}'),
            ],
          ),
          trailing: benef.statut.isEmpty
              ? null
              : _StatusChip(label: benef.statut),
        );
      }).toList(),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colorScheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientHeader extends StatelessWidget {
  const _ClientHeader({
    required this.clientId,
    required this.isLoading,
    required this.onRefresh,
  });

  final String clientId;
  final bool isLoading;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Client Moka',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  clientId.isEmpty
                      ? 'Aucun identifiant défini'
                      : 'ID utilisé : $clientId',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  "Modifiez `defaultMokaClientId` pour changer d'identifiant.",
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: isLoading ? null : onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Rafraîchir'),
          ),
        ],
      ),
    );
  }
}

String _initials(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '?';
  final parts = trimmed.split(RegExp(r'\s+'));
  final String firstInitial =
      parts.first.isNotEmpty ? parts.first.substring(0, 1) : '?';
  String secondInitial = '';
  if (parts.length > 1 && parts.last.isNotEmpty) {
    secondInitial = parts.last.substring(0, 1);
  } else if (parts.first.length > 1) {
    secondInitial = parts.first.substring(1, 2);
  }
  return (firstInitial + secondInitial).toUpperCase();
}

String _formatDate(String raw) {
  final input = raw.trim();
  if (input.isEmpty) return raw;
  final normalized = input.replaceAll('/', '-');
  DateTime? parsed;
  try {
    parsed = DateTime.parse(normalized);
  } catch (_) {
    final match = RegExp(r'^(?<d>\d{1,2})-(?<m>\d{1,2})-(?<y>\d{4})$')
        .firstMatch(normalized);
    if (match != null) {
      final day = int.tryParse(match.namedGroup('d') ?? '');
      final month = int.tryParse(match.namedGroup('m') ?? '');
      final year = int.tryParse(match.namedGroup('y') ?? '');
      if (day != null && month != null && year != null) {
        parsed = DateTime(year, month, day);
      }
    }
  }
  if (parsed == null) {
    return raw;
  }
  final day = parsed.day.toString().padLeft(2, '0');
  final month = parsed.month.toString().padLeft(2, '0');
  final year = parsed.year.toString().padLeft(4, '0');
  return '$day-$month-$year';
}

