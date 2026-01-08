import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/models/models.dart';
import '../providers/codeplug_provider.dart';

class ZoneDetailScreen extends ConsumerWidget {
  const ZoneDetailScreen({super.key, required this.zoneId});

  final String zoneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final codeplug = ref.watch(codeplugNotifierProvider);

    if (codeplug == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.noConfigLoaded)),
      );
    }

    final zone = codeplug.zoneById(zoneId);
    if (zone == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Zone not found')),
      );
    }

    final zoneChannels = zone.channelIds
        .map((id) => codeplug.channelById(id))
        .whereType<Channel>()
        .toList();

    final availableChannels = codeplug.channels
        .where((c) => !zone.channelIds.contains(c.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(zone.name),
      ),
      body: Row(
        children: [
          // Zone channels (left side)
          Expanded(
            child: _ZoneChannelsPanel(
              zone: zone,
              channels: zoneChannels,
              l10n: l10n,
            ),
          ),
          const VerticalDivider(width: 1),
          // Available channels (right side)
          Expanded(
            child: _AvailableChannelsPanel(
              zone: zone,
              channels: availableChannels,
              l10n: l10n,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneChannelsPanel extends ConsumerWidget {
  const _ZoneChannelsPanel({
    required this.zone,
    required this.channels,
    required this.l10n,
  });

  final Zone zone;
  final List<Channel> channels;
  final L10n l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.zoneChannels,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: DragTarget<Channel>(
            onAcceptWithDetails: (details) {
              final channel = details.data;
              final updatedZone = zone.copyWith(
                channelIds: [...zone.channelIds, channel.id],
              );
              ref.read(codeplugNotifierProvider.notifier).updateZone(updatedZone);
            },
            builder: (context, candidateData, rejectedData) {
              final isHovering = candidateData.isNotEmpty;

              if (channels.isEmpty && !isHovering) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.noChannelsInZone,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.dragChannelsHint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                decoration: isHovering
                    ? BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.3),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      )
                    : null,
                child: ReorderableListView.builder(
                  itemCount: channels.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex--;
                    final newChannelIds = List<String>.from(zone.channelIds);
                    final item = newChannelIds.removeAt(oldIndex);
                    newChannelIds.insert(newIndex, item);
                    ref.read(codeplugNotifierProvider.notifier).updateZone(
                          zone.copyWith(channelIds: newChannelIds),
                        );
                  },
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    return _ChannelTile(
                      key: ValueKey(channel.id),
                      channel: channel,
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        tooltip: l10n.removeFromZone,
                        onPressed: () {
                          final updatedZone = zone.copyWith(
                            channelIds: zone.channelIds
                                .where((id) => id != channel.id)
                                .toList(),
                          );
                          ref.read(codeplugNotifierProvider.notifier).updateZone(updatedZone);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AvailableChannelsPanel extends ConsumerWidget {
  const _AvailableChannelsPanel({
    required this.zone,
    required this.channels,
    required this.l10n,
  });

  final Zone zone;
  final List<Channel> channels;
  final L10n l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.availableChannels,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: channels.isEmpty
              ? Center(
                  child: Text(
                    l10n.channelsEmpty,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                )
              : ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    return Draggable<Channel>(
                      data: channel,
                      feedback: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            channel.name.isEmpty ? l10n.unnamed : channel.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: _ChannelTile(channel: channel),
                      ),
                      child: _ChannelTile(
                        channel: channel,
                        trailing: IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          tooltip: l10n.addToZone,
                          onPressed: () {
                            final updatedZone = zone.copyWith(
                              channelIds: [...zone.channelIds, channel.id],
                            );
                            ref.read(codeplugNotifierProvider.notifier).updateZone(updatedZone);
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ChannelTile extends StatelessWidget {
  const _ChannelTile({
    super.key,
    required this.channel,
    this.trailing,
  });

  final Channel channel;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 16,
        backgroundColor:
            channel.mode == ChannelMode.digital ? Colors.blue : Colors.orange,
        child: Icon(
          channel.mode == ChannelMode.digital
              ? Icons.radio
              : Icons.radio_button_checked,
          size: 16,
          color: Colors.white,
        ),
      ),
      title: Text(
        channel.name.isEmpty ? '(unnamed)' : channel.name,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        '${channel.rxFrequency.toStringAsFixed(4)} MHz',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: trailing,
      dense: true,
    );
  }
}
