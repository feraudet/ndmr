import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/help_tooltip.dart';
import '../../data/models/models.dart';
import '../providers/codeplug_provider.dart';
import '../widgets/channel_form_dialog.dart';

const _uuid = Uuid();

class ChannelsScreen extends ConsumerStatefulWidget {
  const ChannelsScreen({super.key});

  @override
  ConsumerState<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends ConsumerState<ChannelsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  ChannelMode? _modeFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Channel> _filterChannels(List<Channel> channels) {
    var filtered = channels;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((c) {
        return c.name.toLowerCase().contains(query) ||
            c.rxFrequency.toString().contains(query) ||
            c.txFrequency.toString().contains(query);
      }).toList();
    }

    if (_modeFilter != null) {
      filtered = filtered.where((c) => c.mode == _modeFilter).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final codeplug = ref.watch(codeplugNotifierProvider);

    if (codeplug == null) {
      return Center(child: Text(l10n.noConfigLoaded));
    }

    final allChannels = codeplug.channels;
    final filteredChannels = _filterChannels(allChannels);

    return Scaffold(
      body: Column(
        children: [
          // Search and filter bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: _getSearchHint(l10n),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                const SizedBox(width: 8),
                // Mode filter chips
                FilterChip(
                  label: Text(l10n.modeDigital),
                  selected: _modeFilter == ChannelMode.digital,
                  onSelected: (selected) {
                    setState(() {
                      _modeFilter = selected ? ChannelMode.digital : null;
                    });
                  },
                ),
                const SizedBox(width: 4),
                FilterChip(
                  label: Text(l10n.modeAnalog),
                  selected: _modeFilter == ChannelMode.analog,
                  onSelected: (selected) {
                    setState(() {
                      _modeFilter = selected ? ChannelMode.analog : null;
                    });
                  },
                ),
              ],
            ),
          ),
          // Results count
          if (allChannels.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${filteredChannels.length} / ${allChannels.length} ${l10n.channels.toLowerCase()}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const Spacer(),
                  HelpTooltip(message: l10n.helpChannel, iconSize: 16),
                ],
              ),
            ),
          const Divider(height: 1),
          // Channel list
          Expanded(
            child: allChannels.isEmpty
                ? _buildEmptyState(context, l10n)
                : filteredChannels.isEmpty
                    ? _buildNoResultsState(context, l10n)
                    : ListView.builder(
                        itemCount: filteredChannels.length,
                        itemBuilder: (context, index) {
                          final channel = filteredChannels[index];
                          return _ChannelTile(
                            channel: channel,
                            l10n: l10n,
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddChannelDialog(context),
        tooltip: l10n.addChannel,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getSearchHint(L10n l10n) => l10n.searchChannelsHint;

  Widget _buildEmptyState(BuildContext context, L10n l10n) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.radio_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.channelsEmpty,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(l10n.channelsEmptyHint),
          ],
        ),
      );

  Widget _buildNoResultsState(BuildContext context, L10n l10n) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noResults,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _modeFilter = null;
                });
              },
              child: Text(l10n.clearFilters),
            ),
          ],
        ),
      );

  Future<void> _showAddChannelDialog(BuildContext context) async {
    final channel = await showDialog<Channel>(
      context: context,
      builder: (context) => ChannelFormDialog(
        channel: Channel(
          id: _uuid.v4(),
          name: '',
          rxFrequency: 430.0,
          txFrequency: 430.0,
        ),
      ),
    );

    if (channel != null) {
      ref.read(codeplugNotifierProvider.notifier).addChannel(channel);
    }
  }
}

class _ChannelTile extends ConsumerWidget {
  const _ChannelTile({
    required this.channel,
    required this.l10n,
  });

  final Channel channel;
  final L10n l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
        leading: CircleAvatar(
          backgroundColor: channel.mode == ChannelMode.digital
              ? Colors.blue
              : Colors.orange,
          child: Icon(
            channel.mode == ChannelMode.digital
                ? Icons.radio
                : Icons.radio_button_checked,
            color: Colors.white,
          ),
        ),
        title: Text(channel.name.isEmpty ? l10n.unnamed : channel.name),
        subtitle: Text(
          'RX: ${channel.rxFrequency.toStringAsFixed(4)} MHz  '
          'TX: ${channel.txFrequency.toStringAsFixed(4)} MHz',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (channel.mode == ChannelMode.digital)
              Chip(
                label: Text('TS${channel.timeslot}'),
                visualDensity: VisualDensity.compact,
              ),
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: l10n.editChannel,
              onPressed: () => _showEditDialog(context, ref),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: l10n.deleteChannel,
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
      );

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref) async {
    final updated = await showDialog<Channel>(
      context: context,
      builder: (context) => ChannelFormDialog(channel: channel),
    );

    if (updated != null) {
      ref.read(codeplugNotifierProvider.notifier).updateChannel(updated);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteChannel),
        content: Text(l10n.deleteChannelConfirm(channel.name)),
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
      ref.read(codeplugNotifierProvider.notifier).deleteChannel(channel.id);
    }
  }
}
