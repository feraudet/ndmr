import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/help_tooltip.dart';
import '../../data/models/models.dart';
import '../../data/repositories/codeplug_repository.dart';
import '../../data/services/qdmr_import_service.dart';
import '../providers/codeplug_provider.dart';
import '../widgets/setup_wizard.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Future<void> _importQdmr(
    BuildContext context,
    WidgetRef ref,
    L10n l10n,
  ) async {
    final service = QdmrImportService();
    final codeplug = await service.importFromFile();

    if (!context.mounted) return;

    if (codeplug != null) {
      ref.read(codeplugNotifierProvider.notifier).load(codeplug);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.importQdmrSuccess(codeplug.name))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.importQdmrError)),
      );
    }
  }

  Widget _buildChannelDetails(Codeplug codeplug, L10n l10n) {
    final digital = codeplug.channels.where((c) => c.mode == ChannelMode.digital).length;
    final analog = codeplug.channels.length - digital;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DetailChip(
          icon: Icons.radio,
          label: '$digital ${l10n.statsDigitalChannels}',
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        _DetailChip(
          icon: Icons.radio_button_checked,
          label: '$analog ${l10n.statsAnalogChannels}',
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildContactDetails(Codeplug codeplug, L10n l10n) {
    final groups = codeplug.contacts.where((c) => c.callType == CallType.group).length;
    final privates = codeplug.contacts.where((c) => c.callType == CallType.private).length;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DetailChip(
          icon: Icons.group,
          label: '$groups ${l10n.statsTalkGroups}',
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        _DetailChip(
          icon: Icons.person,
          label: '$privates ${l10n.statsPrivateContacts}',
          color: Colors.green,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final codeplug = ref.watch(codeplugNotifierProvider);

    if (codeplug == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.radio,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.welcomeTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.welcomeSubtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => SetupWizard(
                          onComplete: () => Navigator.of(context).pop(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: Text(l10n.newConfig),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    final repo = ref.read(codeplugRepositoryProvider);
                    final codeplug = await repo.loadFromFile();
                    if (codeplug != null) {
                      ref.read(codeplugNotifierProvider.notifier).load(codeplug);
                    }
                  },
                  icon: const Icon(Icons.folder_open),
                  label: Text(l10n.openFile),
                ),
                OutlinedButton.icon(
                  onPressed: () => _importQdmr(context, ref, l10n),
                  icon: const Icon(Icons.upload_file),
                  label: Text(l10n.importQdmr),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            codeplug.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            codeplug.radioModel,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCard(
                icon: Icons.radio,
                label: l10n.channels,
                value: codeplug.channels.length.toString(),
                helpText: l10n.helpChannel,
                details: _buildChannelDetails(codeplug, l10n),
              ),
              _StatCard(
                icon: Icons.folder,
                label: l10n.zones,
                value: codeplug.zones.length.toString(),
                helpText: l10n.helpZone,
              ),
              _StatCard(
                icon: Icons.contacts,
                label: l10n.contacts,
                value: codeplug.contacts.length.toString(),
                helpText: l10n.helpContact,
                details: _buildContactDetails(codeplug, l10n),
              ),
              _StatCard(
                icon: Icons.playlist_play,
                label: l10n.scanLists,
                value: codeplug.scanLists.length.toString(),
                helpText: l10n.helpScanList,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.settingsIdentity,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SettingRow(
                    label: l10n.fieldDmrId,
                    value: codeplug.settings.dmrId == 0
                        ? '-'
                        : codeplug.settings.dmrId.toString(),
                    helpText: l10n.helpDmrId,
                  ),
                  _SettingRow(
                    label: l10n.fieldCallsign,
                    value: codeplug.settings.callsign.isEmpty
                        ? '-'
                        : codeplug.settings.callsign,
                    helpText: l10n.helpCallsign,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.helpText,
    this.details,
  });

  final IconData icon;
  final String label;
  final String value;
  final String helpText;
  final Widget? details;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  HelpTooltip(message: helpText, iconSize: 14),
                ],
              ),
              if (details != null) ...[
                const SizedBox(height: 8),
                details!,
              ],
            ],
          ),
        ),
      );
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    required this.value,
    required this.helpText,
  });

  final String label;
  final String value;
  final String helpText;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            HelpTooltip(message: helpText, iconSize: 14),
            const SizedBox(width: 8),
            Text(value),
          ],
        ),
      );
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: color),
            ),
          ],
        ),
      );
}
