import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/help_tooltip.dart';
import '../../data/models/models.dart';
import '../providers/codeplug_provider.dart';
import 'zone_detail_screen.dart';

const _uuid = Uuid();

class ZonesScreen extends ConsumerWidget {
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final codeplug = ref.watch(codeplugNotifierProvider);

    if (codeplug == null) {
      return Center(child: Text(l10n.noConfigLoaded));
    }

    final zones = codeplug.zones;

    return Scaffold(
      body: Column(
        children: [
          // Header with help
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${zones.length} ${l10n.zones.toLowerCase()}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const Spacer(),
                HelpTooltip(message: l10n.helpZone, iconSize: 16),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: zones.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.zonesEmpty,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(l10n.zonesEmptyHint),
                      ],
                    ),
                  )
                : ReorderableListView.builder(
                    itemCount: zones.length,
                    onReorder: (oldIndex, newIndex) {
                      ref
                          .read(codeplugNotifierProvider.notifier)
                          .reorderZones(oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      final zone = zones[index];
                      return ListTile(
                        key: ValueKey(zone.id),
                        leading: const CircleAvatar(child: Icon(Icons.folder)),
                        title: Text(zone.name),
                        subtitle: Text(l10n.zoneChannelCount(zone.channelIds.length)),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => ZoneDetailScreen(zoneId: zone.id),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.playlist_add),
                              tooltip: l10n.manageChannels,
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) => ZoneDetailScreen(zoneId: zone.id),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: l10n.editZone,
                              onPressed: () => _showEditDialog(context, ref, zone, l10n),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              tooltip: l10n.duplicateZone,
                              onPressed: () => _duplicateZone(ref, zone),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: l10n.deleteZone,
                              onPressed: () => _confirmDelete(context, ref, zone, l10n),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref, l10n),
        tooltip: l10n.addZone,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _duplicateZone(WidgetRef ref, Zone zone) {
    final duplicate = Zone(
      id: _uuid.v4(),
      name: '${zone.name} (copy)',
      channelIds: List.from(zone.channelIds),
    );
    ref.read(codeplugNotifierProvider.notifier).addZone(duplicate);
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref, L10n l10n) async {
    final name = await _showNameDialog(context, l10n.addZone, '', l10n);
    if (name != null && name.isNotEmpty) {
      ref.read(codeplugNotifierProvider.notifier).addZone(
            Zone(id: _uuid.v4(), name: name),
          );
    }
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    Zone zone,
    L10n l10n,
  ) async {
    final name = await _showNameDialog(context, l10n.editZone, zone.name, l10n);
    if (name != null && name.isNotEmpty) {
      ref.read(codeplugNotifierProvider.notifier).updateZone(
            zone.copyWith(name: name),
          );
    }
  }

  Future<String?> _showNameDialog(
    BuildContext context,
    String title,
    String initialValue,
    L10n l10n,
  ) async {
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l10n.fieldName),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Zone zone,
    L10n l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteZone),
        content: Text('${l10n.delete} "${zone.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(codeplugNotifierProvider.notifier).deleteZone(zone.id);
    }
  }
}
