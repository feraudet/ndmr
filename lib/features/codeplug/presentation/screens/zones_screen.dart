import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/models.dart';
import '../providers/codeplug_provider.dart';

const _uuid = Uuid();

class ZonesScreen extends ConsumerWidget {
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeplug = ref.watch(codeplugNotifierProvider);

    if (codeplug == null) {
      return const Center(child: Text('No codeplug loaded'));
    }

    final zones = codeplug.zones;

    return Scaffold(
      body: zones.isEmpty
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
                    'No zones yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Zones help organize your channels'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: zones.length,
              itemBuilder: (context, index) {
                final zone = zones[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.folder)),
                  title: Text(zone.name),
                  subtitle: Text('${zone.channelIds.length} channels'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditDialog(context, ref, zone),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDelete(context, ref, zone),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final name = await _showNameDialog(context, 'Add Zone', '');
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
  ) async {
    final name = await _showNameDialog(context, 'Edit Zone', zone.name);
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
  ) async {
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Zone zone,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Zone'),
        content: Text('Delete "${zone.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(codeplugNotifierProvider.notifier).deleteZone(zone.id);
    }
  }
}
