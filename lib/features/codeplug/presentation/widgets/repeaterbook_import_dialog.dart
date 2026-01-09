import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/services/repeaterbook_service.dart';
import '../providers/codeplug_provider.dart';

class RepeaterbookImportDialog extends ConsumerStatefulWidget {
  const RepeaterbookImportDialog({super.key});

  @override
  ConsumerState<RepeaterbookImportDialog> createState() =>
      _RepeaterbookImportDialogState();
}

class _RepeaterbookImportDialogState
    extends ConsumerState<RepeaterbookImportDialog> {
  final _service = RepeaterbookService();
  RepeaterbookCountry _selectedCountry = repeaterbookCountries.first;
  String _city = '';
  bool _isLoading = false;
  String? _error;
  List<Repeater>? _results;
  final Set<int> _selectedIndices = {};

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _results = null;
      _selectedIndices.clear();
    });

    try {
      final results = await _service.searchDmrRepeaters(
        countryCode: _selectedCountry.code,
        city: _city.isNotEmpty ? _city : null,
      );

      setState(() {
        _results = results.where((r) => r.isOperational).toList();
        _isLoading = false;
        // Select all by default
        _selectedIndices.addAll(
          List.generate(_results!.length, (i) => i),
        );
      });
    } on RepeaterbookException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    }
  }

  void _import() {
    if (_results == null || _selectedIndices.isEmpty) return;

    final selectedRepeaters = _selectedIndices
        .map((i) => _results![i])
        .toList();

    final channels = _service.repeatersToChannels(selectedRepeaters);

    for (final channel in channels) {
      ref.read(codeplugNotifierProvider.notifier).addChannel(channel);
    }

    Navigator.pop(context, channels.length);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.cell_tower, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    l10n.repeaterbookTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.repeaterbookSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              // Search form
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<RepeaterbookCountry>(
                      value: _selectedCountry,
                      decoration: InputDecoration(
                        labelText: l10n.repeaterbookCountry,
                        border: const OutlineInputBorder(),
                      ),
                      items: repeaterbookCountries
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.name),
                              ))
                          .toList(),
                      onChanged: (c) {
                        if (c != null) setState(() => _selectedCountry = c);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: l10n.repeaterbookCity,
                        hintText: l10n.repeaterbookCityHint,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (v) => _city = v,
                      onSubmitted: (_) => _search(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _search,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search),
                    label: Text(l10n.repeaterbookSearch),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Results
              Expanded(
                child: _buildResults(l10n),
              ),
              const SizedBox(height: 16),
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_results != null && _results!.isNotEmpty) ...[
                    Text(
                      l10n.repeaterbookSelected(_selectedIndices.length, _results!.length),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (_selectedIndices.length == _results!.length) {
                            _selectedIndices.clear();
                          } else {
                            _selectedIndices.addAll(
                              List.generate(_results!.length, (i) => i),
                            );
                          }
                        });
                      },
                      child: Text(
                        _selectedIndices.length == _results!.length
                            ? l10n.repeaterbookDeselectAll
                            : l10n.repeaterbookSelectAll,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _selectedIndices.isNotEmpty ? _import : null,
                    icon: const Icon(Icons.download),
                    label: Text(l10n.repeaterbookImport),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(L10n l10n) {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ),
      );
    }

    if (_results == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cell_tower,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.repeaterbookHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    if (_results!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48),
            const SizedBox(height: 16),
            Text(l10n.noResults),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _results!.length,
      itemBuilder: (context, index) {
        final repeater = _results![index];
        final isSelected = _selectedIndices.contains(index);

        return CheckboxListTile(
          value: isSelected,
          onChanged: (v) {
            setState(() {
              if (v == true) {
                _selectedIndices.add(index);
              } else {
                _selectedIndices.remove(index);
              }
            });
          },
          title: Text(
            repeater.callsign ?? 'DMR ${repeater.frequency.toStringAsFixed(4)}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            '${repeater.frequency.toStringAsFixed(4)} MHz • ${repeater.city ?? ''} • CC ${repeater.colorCode ?? '?'}',
          ),
          secondary: const Icon(Icons.cell_tower),
          dense: true,
        );
      },
    );
  }
}
