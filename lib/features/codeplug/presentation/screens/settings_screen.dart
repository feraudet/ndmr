import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/locale/locale_provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/help_tooltip.dart';
import '../../data/models/models.dart';
import '../providers/codeplug_provider.dart';
import 'about_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _dmrIdController;
  late TextEditingController _callsignController;
  late TextEditingController _intro1Controller;
  late TextEditingController _intro2Controller;

  @override
  void initState() {
    super.initState();
    _dmrIdController = TextEditingController();
    _callsignController = TextEditingController();
    _intro1Controller = TextEditingController();
    _intro2Controller = TextEditingController();
  }

  @override
  void dispose() {
    _dmrIdController.dispose();
    _callsignController.dispose();
    _intro1Controller.dispose();
    _intro2Controller.dispose();
    super.dispose();
  }

  void _loadSettings(RadioSettings settings) {
    _dmrIdController.text =
        settings.dmrId == 0 ? '' : settings.dmrId.toString();
    _callsignController.text = settings.callsign;
    _intro1Controller.text = settings.introLine1;
    _intro2Controller.text = settings.introLine2;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final codeplug = ref.watch(codeplugNotifierProvider);

    if (codeplug == null) {
      return Center(child: Text(l10n.noConfigLoaded));
    }

    // Load settings on first build
    if (_dmrIdController.text.isEmpty && codeplug.settings.dmrId != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadSettings(codeplug.settings);
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settings,
            style: Theme.of(context).textTheme.headlineSmall,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _dmrIdController,
                          decoration: InputDecoration(
                            labelText: l10n.fieldDmrId,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      HelpTooltip(message: l10n.helpDmrId),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _callsignController,
                          decoration: InputDecoration(
                            labelText: l10n.fieldCallsign,
                            border: const OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.characters,
                        ),
                      ),
                      HelpTooltip(message: l10n.helpCallsign),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsDisplay,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _intro1Controller,
                    decoration: InputDecoration(
                      labelText: l10n.fieldIntroLine1,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _intro2Controller,
                    decoration: InputDecoration(
                      labelText: l10n.fieldIntroLine2,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsTheme,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _ThemeSelector(l10n: l10n),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsLanguage,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _LanguageSelector(l10n: l10n),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _saveSettings(l10n),
            icon: const Icon(Icons.save),
            label: Text(l10n.save),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.aboutTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _saveSettings(L10n l10n) {
    final codeplug = ref.read(codeplugNotifierProvider);
    if (codeplug == null) return;

    final settings = codeplug.settings.copyWith(
      dmrId: int.tryParse(_dmrIdController.text) ?? 0,
      callsign: _callsignController.text.toUpperCase(),
      introLine1: _intro1Controller.text,
      introLine2: _intro2Controller.text,
    );

    ref.read(codeplugNotifierProvider.notifier).updateSettings(settings);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsSaved)),
    );
  }
}

class _ThemeSelector extends ConsumerWidget {
  const _ThemeSelector({required this.l10n});

  final L10n l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeModeNotifierProvider);

    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(
          value: ThemeMode.system,
          label: Text(l10n.themeSystem),
          icon: const Icon(Icons.settings_brightness),
        ),
        ButtonSegment(
          value: ThemeMode.light,
          label: Text(l10n.themeLight),
          icon: const Icon(Icons.light_mode),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text(l10n.themeDark),
          icon: const Icon(Icons.dark_mode),
        ),
      ],
      selected: {currentTheme},
      onSelectionChanged: (selected) {
        ref.read(themeModeNotifierProvider.notifier).setThemeMode(selected.first);
      },
    );
  }
}

class _LanguageSelector extends ConsumerWidget {
  const _LanguageSelector({required this.l10n});

  final L10n l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeNotifierProvider);

    return SegmentedButton<Locale?>(
      segments: [
        ButtonSegment(
          value: null,
          label: Text(l10n.languageSystem),
          icon: const Icon(Icons.language),
        ),
        const ButtonSegment(
          value: Locale('en'),
          label: Text('English'),
        ),
        const ButtonSegment(
          value: Locale('fr'),
          label: Text('Français'),
        ),
      ],
      selected: {currentLocale},
      onSelectionChanged: (selected) {
        ref.read(localeNotifierProvider.notifier).setLocale(selected.first);
      },
    );
  }
}
