import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/repositories/codeplug_repository.dart';
import '../providers/codeplug_provider.dart';
import 'channels_screen.dart';
import 'contacts_screen.dart';
import 'dashboard_screen.dart';
import 'settings_screen.dart';
import 'zones_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.configSaved)),
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
      4 => const SettingsScreen(),
      _ => const DashboardScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 800;
    final isExtraWide = width >= 1200;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
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
    );
  }
}
