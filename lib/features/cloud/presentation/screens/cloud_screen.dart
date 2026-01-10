import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../codeplug/presentation/providers/codeplug_provider.dart';
import '../../data/services/sync_service.dart';
import '../../data/services/api_service.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});

final cloudCodeplugsProvider =
    FutureProvider<List<CloudCodeplugListItem>>((ref) async {
  final authState = ref.watch(authProvider);
  if (!authState.isAuthenticated) {
    return [];
  }
  final syncService = ref.watch(syncServiceProvider);
  return syncService.listCodeplugs();
});

class CloudScreen extends ConsumerStatefulWidget {
  const CloudScreen({super.key});

  @override
  ConsumerState<CloudScreen> createState() => _CloudScreenState();
}

class _CloudScreenState extends ConsumerState<CloudScreen> {
  bool _isSyncing = false;

  Future<void> _saveToCloud() async {
    final l10n = L10n.of(context)!;
    final codeplug = ref.read(codeplugNotifierProvider);
    if (codeplug == null) return;

    setState(() => _isSyncing = true);

    try {
      final syncService = ref.read(syncServiceProvider);
      await syncService.createCodeplug(
        name: codeplug.name,
        codeplug: codeplug,
      );

      ref.invalidate(cloudCodeplugsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.cloudSyncSuccess)),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.cloudSyncError}: ${e.message}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _loadFromCloud(String id) async {
    final l10n = L10n.of(context)!;

    setState(() => _isSyncing = true);

    try {
      final syncService = ref.read(syncServiceProvider);
      final cloudCodeplug = await syncService.getCodeplug(id);
      final codeplug = cloudCodeplug.toCodeplug();

      ref.read(codeplugNotifierProvider.notifier).load(codeplug);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.cloudSyncSuccess)),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.cloudSyncError}: ${e.message}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _deleteFromCloud(String id, String name) async {
    final l10n = L10n.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cloudDelete),
        content: Text(l10n.cloudDeleteConfirm(name)),
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

    if (confirmed != true) return;

    try {
      final syncService = ref.read(syncServiceProvider);
      await syncService.deleteCodeplug(id);
      ref.invalidate(cloudCodeplugsProvider);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.cloudSyncError}: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final codeplug = ref.watch(codeplugNotifierProvider);

    // Not logged in - show login prompt
    if (!authState.isAuthenticated) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.cloudNotLoggedIn,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.login),
              label: Text(l10n.cloudSignInToSync),
            ),
          ],
        ),
      );
    }

    // Logged in - show cloud codeplugs
    final cloudCodeplugsAsync = ref.watch(cloudCodeplugsProvider);

    return Column(
      children: [
        // Header with user info and actions
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authState.user?.email ?? '',
                      style: theme.textTheme.titleSmall,
                    ),
                    if (authState.user?.callsign != null)
                      Text(
                        authState.user!.callsign!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                  ],
                ),
              ),
              if (codeplug != null)
                FilledButton.icon(
                  onPressed: _isSyncing ? null : _saveToCloud,
                  icon: _isSyncing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.cloud_upload),
                  label: Text(l10n.cloudSaveToCloud),
                ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => ref.invalidate(cloudCodeplugsProvider),
                icon: const Icon(Icons.refresh),
                tooltip: l10n.mapRefresh,
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    ref.read(authProvider.notifier).logout();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        const Icon(Icons.logout),
                        const SizedBox(width: 8),
                        Text(l10n.cloudLogout),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Cloud codeplugs list
        Expanded(
          child: cloudCodeplugsAsync.when(
            data: (codeplugs) {
              if (codeplugs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_outlined,
                        size: 64,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.cloudNoCodeplugs,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.cloudNoCodeplugsHint,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: codeplugs.length,
                itemBuilder: (context, index) {
                  final item = codeplugs[index];
                  final dateFormat = DateFormat.yMd().add_Hm();

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.settings_input_antenna,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      title: Text(item.name),
                      subtitle: Text(
                        l10n.cloudLastSync(dateFormat.format(item.updatedAt)),
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.cloud_download),
                            tooltip: l10n.cloudLoadFromCloud,
                            onPressed:
                                _isSyncing ? null : () => _loadFromCloud(item.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: l10n.cloudDelete,
                            onPressed: () =>
                                _deleteFromCloud(item.id, item.name),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    error.toString(),
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => ref.invalidate(cloudCodeplugsProvider),
                    child: Text(l10n.mapRefresh),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
