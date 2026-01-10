import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/repositories/codeplug_repository.dart';
import '../../data/services/pdf_export_service.dart';
import '../../data/services/validation_service.dart';
import '../providers/codeplug_provider.dart';
import '../providers/dirty_state_provider.dart';
import '../providers/history_provider.dart';
import 'channels_screen.dart';
import 'contacts_screen.dart';
import 'dashboard_screen.dart';
import 'repeater_map_screen.dart';
import 'scan_lists_screen.dart';
import 'settings_screen.dart';
import 'zones_screen.dart';
import '../widgets/repeaterbook_import_dialog.dart';
import '../../../cloud/presentation/screens/cloud_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onExitRequested: _handleExitRequest,
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  Future<AppExitResponse> _handleExitRequest() async {
    final hasUnsavedChanges = ref.read(hasUnsavedChangesProvider);
    if (!hasUnsavedChanges) {
      return AppExitResponse.exit;
    }

    final l10n = L10n.of(context)!;
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.unsavedChangesTitle),
        content: Text(l10n.unsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'discard'),
            child: Text(l10n.discardChanges),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: Text(l10n.dontClose),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'save'),
            child: Text(l10n.saveAndClose),
          ),
        ],
      ),
    );

    switch (result) {
      case 'save':
        await _saveFile();
        return AppExitResponse.exit;
      case 'discard':
        return AppExitResponse.exit;
      default:
        return AppExitResponse.cancel;
    }
  }

  List<NavigationDestination> _buildDestinations(L10n l10n) => [
        NavigationDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: l10n.navDashboard,
        ),
        NavigationDestination(
          icon: const Icon(Icons.radio_outlined),
          selectedIcon: const Icon(Icons.radio),
          label: l10n.navChannels,
        ),
        NavigationDestination(
          icon: const Icon(Icons.folder_outlined),
          selectedIcon: const Icon(Icons.folder),
          label: l10n.navZones,
        ),
        NavigationDestination(
          icon: const Icon(Icons.contacts_outlined),
          selectedIcon: const Icon(Icons.contacts),
          label: l10n.navContacts,
        ),
        NavigationDestination(
          icon: const Icon(Icons.playlist_play_outlined),
          selectedIcon: const Icon(Icons.playlist_play),
          label: l10n.navScanLists,
        ),
        NavigationDestination(
          icon: const Icon(Icons.map_outlined),
          selectedIcon: const Icon(Icons.map),
          label: l10n.navMap,
        ),
        NavigationDestination(
          icon: const Icon(Icons.cloud_outlined),
          selectedIcon: const Icon(Icons.cloud),
          label: l10n.navCloud,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: l10n.navSettings,
        ),
      ];

  List<NavigationRailDestination> _buildRailDestinations(L10n l10n) => [
        NavigationRailDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: Text(l10n.navDashboard),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.radio_outlined),
          selectedIcon: const Icon(Icons.radio),
          label: Text(l10n.navChannels),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.folder_outlined),
          selectedIcon: const Icon(Icons.folder),
          label: Text(l10n.navZones),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.contacts_outlined),
          selectedIcon: const Icon(Icons.contacts),
          label: Text(l10n.navContacts),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.playlist_play_outlined),
          selectedIcon: const Icon(Icons.playlist_play),
          label: Text(l10n.navScanLists),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.map_outlined),
          selectedIcon: const Icon(Icons.map),
          label: Text(l10n.navMap),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.cloud_outlined),
          selectedIcon: const Icon(Icons.cloud),
          label: Text(l10n.navCloud),
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: Text(l10n.navSettings),
        ),
      ];

  Future<void> _openFile() async {
    final l10n = L10n.of(context)!;
    final repo = ref.read(codeplugRepositoryProvider);
    final codeplug = await repo.loadFromFile();
    if (codeplug != null && mounted) {
      ref.read(codeplugNotifierProvider.notifier).load(codeplug);
      ref.read(dirtyStateNotifierProvider.notifier).setInitialState(codeplug);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.configLoaded(codeplug.name))),
        );
      }
    }
  }

  Future<void> _saveFile() async {
    final l10n = L10n.of(context)!;
    final codeplug = ref.read(codeplugNotifierProvider);
    if (codeplug == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noConfigToSave)),
      );
      return;
    }

    final repo = ref.read(codeplugRepositoryProvider);
    final saved = await repo.saveToFile(codeplug);
    if (mounted && saved) {
      ref.read(dirtyStateNotifierProvider.notifier).markAsSaved();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.configSaved)),
      );
    }
  }

  Future<void> _exportPdf() async {
    final l10n = L10n.of(context)!;
    final codeplug = ref.read(codeplugNotifierProvider);
    if (codeplug == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noConfigToSave)),
      );
      return;
    }

    final pdfService = PdfExportService();
    await pdfService.exportToPdf(codeplug);
  }

  Future<void> _openRepeaterbookImport(L10n l10n) async {
    final codeplug = ref.read(codeplugNotifierProvider);
    if (codeplug == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.repeaterbookNoConfig)),
      );
      return;
    }

    final result = await showDialog<int>(
      context: context,
      builder: (context) => const RepeaterbookImportDialog(),
    );

    if (result != null && result > 0 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.repeaterbookSuccess(result))),
      );
    }
  }

  Widget _buildBody() {
    final codeplug = ref.watch(codeplugNotifierProvider);

    if (codeplug == null) {
      return const DashboardScreen();
    }

    return switch (_selectedIndex) {
      0 => const DashboardScreen(),
      1 => const ChannelsScreen(),
      2 => const ZonesScreen(),
      3 => const ContactsScreen(),
      4 => const ScanListsScreen(),
      5 => const RepeaterMapScreen(),
      6 => const CloudScreen(),
      7 => const SettingsScreen(),
      _ => const DashboardScreen(),
    };
  }

  void _validateCodeplug(L10n l10n) {
    final codeplug = ref.read(codeplugNotifierProvider);
    if (codeplug == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noConfigLoaded)),
      );
      return;
    }

    final validationService = ValidationService();
    final result = validationService.validate(codeplug);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.validationTitle),
        content: SizedBox(
          width: 400,
          child: result.issues.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.validationPassed,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.validationPassedHint),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (result.errorCount > 0)
                      _ValidationSummaryChip(
                        icon: Icons.error,
                        color: Colors.red,
                        label: l10n.validationErrors(result.errorCount),
                      ),
                    if (result.warningCount > 0)
                      _ValidationSummaryChip(
                        icon: Icons.warning,
                        color: Colors.orange,
                        label: l10n.validationWarnings(result.warningCount),
                      ),
                    if (result.infoCount > 0)
                      _ValidationSummaryChip(
                        icon: Icons.info,
                        color: Colors.blue,
                        label: l10n.validationInfos(result.infoCount),
                      ),
                    const SizedBox(height: 16),
                    const Divider(),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: result.issues.length,
                        itemBuilder: (context, index) {
                          final issue = result.issues[index];
                          return ListTile(
                            leading: Icon(
                              issue.severity == ValidationSeverity.error
                                  ? Icons.error
                                  : issue.severity == ValidationSeverity.warning
                                      ? Icons.warning
                                      : Icons.info,
                              color: issue.severity == ValidationSeverity.error
                                  ? Colors.red
                                  : issue.severity == ValidationSeverity.warning
                                      ? Colors.orange
                                      : Colors.blue,
                            ),
                            title: Text(issue.message),
                            dense: true,
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 800;
    final isExtraWide = width >= 1200;

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        // File operations
        const SingleActivator(LogicalKeyboardKey.keyO, meta: true): _openFile,
        const SingleActivator(LogicalKeyboardKey.keyO, control: true): _openFile,
        const SingleActivator(LogicalKeyboardKey.keyS, meta: true): _saveFile,
        const SingleActivator(LogicalKeyboardKey.keyS, control: true): _saveFile,
        // Undo/Redo
        const SingleActivator(LogicalKeyboardKey.keyZ, meta: true): () =>
            ref.read(historyNotifierProvider.notifier).undo(),
        const SingleActivator(LogicalKeyboardKey.keyZ, control: true): () =>
            ref.read(historyNotifierProvider.notifier).undo(),
        const SingleActivator(LogicalKeyboardKey.keyZ, meta: true, shift: true): () =>
            ref.read(historyNotifierProvider.notifier).redo(),
        const SingleActivator(LogicalKeyboardKey.keyZ, control: true, shift: true): () =>
            ref.read(historyNotifierProvider.notifier).redo(),
        const SingleActivator(LogicalKeyboardKey.keyY, meta: true): () =>
            ref.read(historyNotifierProvider.notifier).redo(),
        const SingleActivator(LogicalKeyboardKey.keyY, control: true): () =>
            ref.read(historyNotifierProvider.notifier).redo(),
        // Navigation shortcuts (Cmd/Ctrl + 1-5)
        const SingleActivator(LogicalKeyboardKey.digit1, meta: true): () =>
            setState(() => _selectedIndex = 0),
        const SingleActivator(LogicalKeyboardKey.digit1, control: true): () =>
            setState(() => _selectedIndex = 0),
        const SingleActivator(LogicalKeyboardKey.digit2, meta: true): () =>
            setState(() => _selectedIndex = 1),
        const SingleActivator(LogicalKeyboardKey.digit2, control: true): () =>
            setState(() => _selectedIndex = 1),
        const SingleActivator(LogicalKeyboardKey.digit3, meta: true): () =>
            setState(() => _selectedIndex = 2),
        const SingleActivator(LogicalKeyboardKey.digit3, control: true): () =>
            setState(() => _selectedIndex = 2),
        const SingleActivator(LogicalKeyboardKey.digit4, meta: true): () =>
            setState(() => _selectedIndex = 3),
        const SingleActivator(LogicalKeyboardKey.digit4, control: true): () =>
            setState(() => _selectedIndex = 3),
        const SingleActivator(LogicalKeyboardKey.digit5, meta: true): () =>
            setState(() => _selectedIndex = 4),
        const SingleActivator(LogicalKeyboardKey.digit5, control: true): () =>
            setState(() => _selectedIndex = 4),
        const SingleActivator(LogicalKeyboardKey.digit6, meta: true): () =>
            setState(() => _selectedIndex = 5),
        const SingleActivator(LogicalKeyboardKey.digit6, control: true): () =>
            setState(() => _selectedIndex = 5),
        const SingleActivator(LogicalKeyboardKey.digit7, meta: true): () =>
            setState(() => _selectedIndex = 6),
        const SingleActivator(LogicalKeyboardKey.digit7, control: true): () =>
            setState(() => _selectedIndex = 6),
        const SingleActivator(LogicalKeyboardKey.digit8, meta: true): () =>
            setState(() => _selectedIndex = 7),
        const SingleActivator(LogicalKeyboardKey.digit8, control: true): () =>
            setState(() => _selectedIndex = 7),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          ref.watch(hasUnsavedChangesProvider)
              ? '${l10n.appTitle} •'
              : l10n.appTitle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: l10n.undo,
            onPressed: ref.watch(canUndoProvider)
                ? () => ref.read(historyNotifierProvider.notifier).undo()
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            tooltip: l10n.redo,
            onPressed: ref.watch(canRedoProvider)
                ? () => ref.read(historyNotifierProvider.notifier).redo()
                : null,
          ),
          const VerticalDivider(width: 16),
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: l10n.validate,
            onPressed: () => _validateCodeplug(l10n),
          ),
          IconButton(
            icon: const Icon(Icons.file_open),
            tooltip: l10n.openFile,
            onPressed: _openFile,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: l10n.saveFile,
            onPressed: _saveFile,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: l10n.exportPdf,
            onPressed: _exportPdf,
          ),
          IconButton(
            icon: const Icon(Icons.cell_tower),
            tooltip: l10n.repeaterbookTitle,
            onPressed: () => _openRepeaterbookImport(l10n),
          ),
        ],
      ),
      body: Row(
        children: [
          if (isWide)
            NavigationRail(
              extended: isExtraWide,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: _buildRailDestinations(l10n),
            ),
          if (isWide) const VerticalDivider(width: 1),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: _buildDestinations(l10n),
            ),
        ),
      ),
    );
  }
}

class _ValidationSummaryChip extends StatelessWidget {
  const _ValidationSummaryChip({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      );
}
