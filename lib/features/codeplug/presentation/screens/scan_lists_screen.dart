import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/help_tooltip.dart';
import '../../data/models/models.dart';
import '../providers/codeplug_provider.dart';

const _uuid = Uuid();

class ScanListsScreen extends ConsumerWidget {
  const ScanListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final codeplug = ref.watch(codeplugNotifierProvider);

    if (codeplug == null) {
      return Center(child: Text(l10n.noConfigLoaded));
    }

    if (codeplug.scanLists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.playlist_play,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.scanListsEmpty,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.scanListsEmptyHint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _addScanList(context, ref, l10n),
              icon: const Icon(Icons.add),
              label: Text(l10n.addScanList),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: codeplug.scanLists.length,
        onReorder: (oldIndex, newIndex) {
          ref.read(codeplugNotifierProvider.notifier).reorderScanLists(oldIndex, newIndex);
        },
        itemBuilder: (context, index) {
          final scanList = codeplug.scanLists[index];
          return _ScanListTile(
            key: ValueKey(scanList.id),
            scanList: scanList,
            channels: codeplug.channels,
            l10n: l10n,
            onTap: () => _openScanListDetail(context, ref, scanList, codeplug.channels, l10n),
            onEdit: () => _editScanList(context, ref, scanList, l10n),
            onDuplicate: () => _duplicateScanList(ref, scanList),
            onDelete: () => _deleteScanList(ref, scanList.id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addScanList(context, ref, l10n),
        tooltip: l10n.addScanList,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addScanList(BuildContext context, WidgetRef ref, L10n l10n) async {
    final nameController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addScanList),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: l10n.fieldName),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, nameController.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      ref.read(codeplugNotifierProvider.notifier).addScanList(
            ScanList(id: _uuid.v4(), name: result),
          );
    }
  }

  Future<void> _editScanList(
    BuildContext context,
    WidgetRef ref,
    ScanList scanList,
    L10n l10n,
  ) async {
    final nameController = TextEditingController(text: scanList.name);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editScanList),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: l10n.fieldName),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, nameController.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      ref.read(codeplugNotifierProvider.notifier).updateScanList(
            scanList.copyWith(name: result),
          );
    }
  }

  void _duplicateScanList(WidgetRef ref, ScanList scanList) {
    final duplicate = ScanList(
      id: _uuid.v4(),
      name: '${scanList.name} (copy)',
      channelIds: List.from(scanList.channelIds),
      priorityChannelId: scanList.priorityChannelId,
    );
    ref.read(codeplugNotifierProvider.notifier).addScanList(duplicate);
  }

  void _deleteScanList(WidgetRef ref, String id) {
    ref.read(codeplugNotifierProvider.notifier).deleteScanList(id);
  }

  void _openScanListDetail(
    BuildContext context,
    WidgetRef ref,
    ScanList scanList,
    List<Channel> channels,
    L10n l10n,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => _ScanListDetailScreen(
          scanList: scanList,
          channels: channels,
        ),
      ),
    );
  }
}

class _ScanListTile extends StatelessWidget {
  const _ScanListTile({
    super.key,
    required this.scanList,
    required this.channels,
    required this.l10n,
    required this.onTap,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  final ScanList scanList;
  final List<Channel> channels;
  final L10n l10n;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final priorityChannel = scanList.priorityChannelId != null
        ? channels.where((c) => c.id == scanList.priorityChannelId).firstOrNull
        : null;

    return Card(
      child: ListTile(
        leading: const Icon(Icons.playlist_play),
        title: Text(scanList.name.isEmpty ? l10n.unnamed : scanList.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.scanListChannelCount(scanList.channelIds.length)),
            if (priorityChannel != null)
              Text(
                '${l10n.priorityChannel}: ${priorityChannel.name}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: l10n.editScanList,
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: l10n.duplicateScanList,
              onPressed: onDuplicate,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: l10n.deleteScanList,
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _ScanListDetailScreen extends ConsumerStatefulWidget {
  const _ScanListDetailScreen({
    required this.scanList,
    required this.channels,
  });

  final ScanList scanList;
  final List<Channel> channels;

  @override
  ConsumerState<_ScanListDetailScreen> createState() => _ScanListDetailScreenState();
}

class _ScanListDetailScreenState extends ConsumerState<_ScanListDetailScreen> {
  late List<String> _selectedChannelIds;
  String? _priorityChannelId;

  @override
  void initState() {
    super.initState();
    _selectedChannelIds = List.from(widget.scanList.channelIds);
    _priorityChannelId = widget.scanList.priorityChannelId;
  }

  void _save() {
    final updated = widget.scanList.copyWith(
      channelIds: _selectedChannelIds,
      priorityChannelId: _priorityChannelId,
    );
    ref.read(codeplugNotifierProvider.notifier).updateScanList(updated);
    Navigator.pop(context);
  }

  void _addChannel(Channel channel) {
    if (!_selectedChannelIds.contains(channel.id)) {
      setState(() {
        _selectedChannelIds.add(channel.id);
      });
    }
  }

  void _removeChannel(String channelId) {
    setState(() {
      _selectedChannelIds.remove(channelId);
      if (_priorityChannelId == channelId) {
        _priorityChannelId = null;
      }
    });
  }

  void _setPriorityChannel(String? channelId) {
    setState(() {
      _priorityChannelId = channelId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final selectedChannels = _selectedChannelIds
        .map((id) => widget.channels.where((c) => c.id == id).firstOrNull)
        .whereType<Channel>()
        .toList();
    final availableChannels = widget.channels
        .where((c) => !_selectedChannelIds.contains(c.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scanList.name),
        actions: [
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: Text(l10n.save),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // Selected channels (left panel)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        l10n.scanListChannels,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      HelpTooltip(message: l10n.helpScanList),
                    ],
                  ),
                ),
                Expanded(
                  child: selectedChannels.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noChannelsInScanList,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        )
                      : ReorderableListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: selectedChannels.length,
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) newIndex--;
                              final id = _selectedChannelIds.removeAt(oldIndex);
                              _selectedChannelIds.insert(newIndex, id);
                            });
                          },
                          itemBuilder: (context, index) {
                            final channel = selectedChannels[index];
                            final isPriority = channel.id == _priorityChannelId;
                            return Card(
                              key: ValueKey(channel.id),
                              color: isPriority
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : null,
                              child: ListTile(
                                leading: Icon(
                                  isPriority ? Icons.star : Icons.radio,
                                  color: isPriority
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                ),
                                title: Text(channel.name),
                                subtitle: Text(
                                  '${channel.rxFrequency.toStringAsFixed(4)} MHz',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        isPriority ? Icons.star : Icons.star_border,
                                      ),
                                      tooltip: l10n.setPriorityChannel,
                                      onPressed: () => _setPriorityChannel(
                                        isPriority ? null : channel.id,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline),
                                      tooltip: l10n.removeFromScanList,
                                      onPressed: () => _removeChannel(channel.id),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // Available channels (right panel)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.availableChannels,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: availableChannels.isEmpty
                      ? Center(
                          child: Text(
                            l10n.allChannelsAdded,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: availableChannels.length,
                          itemBuilder: (context, index) {
                            final channel = availableChannels[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.radio),
                                title: Text(channel.name),
                                subtitle: Text(
                                  '${channel.rxFrequency.toStringAsFixed(4)} MHz',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  tooltip: l10n.addToScanList,
                                  onPressed: () => _addChannel(channel),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
