import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/services/repeaterbook_service.dart';
import '../providers/codeplug_provider.dart';

class RepeaterMapScreen extends ConsumerStatefulWidget {
  const RepeaterMapScreen({super.key});

  @override
  ConsumerState<RepeaterMapScreen> createState() => _RepeaterMapScreenState();
}

class _RepeaterMapScreenState extends ConsumerState<RepeaterMapScreen> {
  final _mapController = MapController();
  final _repeaterbookService = RepeaterbookService();

  List<Repeater> _repeaters = [];
  bool _isLoading = false;
  String? _error;
  LatLng _center = const LatLng(46.603354, 1.888334); // France center
  double _zoom = 6.0;
  Repeater? _selectedRepeater;
  String _selectedCountry = 'fr';

  @override
  void initState() {
    super.initState();
    _loadRepeaters();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      if (mounted) {
        setState(() {
          _center = LatLng(position.latitude, position.longitude);
          _zoom = 10.0;
        });
        _mapController.move(_center, _zoom);
      }
    } catch (e) {
      // Geolocation not available, use default center
    }
  }

  Future<void> _loadRepeaters() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repeaters = await _repeaterbookService.searchDmrRepeaters(
        countryCode: _selectedCountry,
      );
      if (mounted) {
        setState(() {
          _repeaters = repeaters.where((r) => r.hasCoordinates).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _selectRepeater(Repeater repeater) {
    setState(() {
      _selectedRepeater = repeater;
    });
  }

  void _importRepeater(Repeater repeater) {
    final notifier = ref.read(codeplugNotifierProvider.notifier);
    final channel = repeater.toChannel();
    notifier.addChannel(channel);

    final l10n = L10n.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.repeaterImported(repeater.callsign ?? 'DMR')),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => notifier.deleteChannel(channel.id),
        ),
      ),
    );

    setState(() {
      _selectedRepeater = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);
    final codeplug = ref.watch(codeplugNotifierProvider);

    if (codeplug == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.mapNoCodeplug,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.mapNoCodeplugHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Country selector
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(l10n.mapCountry, style: theme.textTheme.titleSmall),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _selectedCountry,
                items: repeaterbookCountries.map((country) {
                  return DropdownMenuItem(
                    value: country.code,
                    child: Text(country.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCountry = value;
                    });
                    _loadRepeaters();
                  }
                },
              ),
              const SizedBox(width: 16),
              if (_isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Text(
                  l10n.mapRepeaterCount(_repeaters.length),
                  style: theme.textTheme.bodySmall,
                ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.my_location),
                tooltip: l10n.mapMyLocation,
                onPressed: _getCurrentLocation,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: l10n.mapRefresh,
                onPressed: _loadRepeaters,
              ),
            ],
          ),
        ),
        // Map
        Expanded(
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _center,
                  initialZoom: _zoom,
                  onTap: (_, __) {
                    setState(() {
                      _selectedRepeater = null;
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'app.ndmr',
                  ),
                  MarkerLayer(
                    markers: _repeaters
                        .where((r) => r.hasCoordinates)
                        .map((repeater) => _buildMarker(repeater, theme))
                        .toList(),
                  ),
                ],
              ),
              // Error message
              if (_error != null)
                Positioned(
                  top: 8,
                  left: 8,
                  right: 8,
                  child: Card(
                    color: theme.colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _error!,
                              style: TextStyle(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(() => _error = null),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Selected repeater info
              if (_selectedRepeater != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _RepeaterInfoCard(
                    repeater: _selectedRepeater!,
                    onImport: () => _importRepeater(_selectedRepeater!),
                    onClose: () => setState(() => _selectedRepeater = null),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Marker _buildMarker(Repeater repeater, ThemeData theme) {
    final isSelected = _selectedRepeater == repeater;
    final isOperational = repeater.isOperational;

    return Marker(
      point: LatLng(repeater.latitude!, repeater.longitude!),
      width: isSelected ? 48 : 40,
      height: isSelected ? 48 : 40,
      child: GestureDetector(
        onTap: () => _selectRepeater(repeater),
        child: Container(
          decoration: BoxDecoration(
            color: isOperational
                ? (isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primaryContainer)
                : (isSelected
                    ? theme.colorScheme.outline
                    : theme.colorScheme.outlineVariant),
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
              width: isSelected ? 3 : 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            Icons.cell_tower,
            size: isSelected ? 24 : 20,
            color: isOperational
                ? (isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onPrimaryContainer)
                : (isSelected
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.outline),
          ),
        ),
      ),
    );
  }
}

class _RepeaterInfoCard extends StatelessWidget {
  const _RepeaterInfoCard({
    required this.repeater,
    required this.onImport,
    required this.onClose,
  });

  final Repeater repeater;
  final VoidCallback onImport;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cell_tower,
                  color: repeater.isOperational
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        repeater.callsign ?? 'DMR Repeater',
                        style: theme.textTheme.titleMedium,
                      ),
                      if (repeater.city != null)
                        Text(
                          '${repeater.city}${repeater.state != null ? ', ${repeater.state}' : ''}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                    ],
                  ),
                ),
                if (repeater.isOperational)
                  Chip(
                    label: Text(
                      l10n.mapOnAir,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.green.shade100,
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: Icons.radio,
                  label: '${repeater.frequency.toStringAsFixed(4)} MHz',
                ),
                if (repeater.colorCode != null)
                  _InfoChip(
                    icon: Icons.color_lens,
                    label: 'CC ${repeater.colorCode}',
                  ),
                if (repeater.dmrId != null)
                  _InfoChip(
                    icon: Icons.tag,
                    label: 'ID ${repeater.dmrId}',
                  ),
              ],
            ),
            if (repeater.notes != null && repeater.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                repeater.notes!,
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  onPressed: onImport,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.mapImportRepeater),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.outline),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
