import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../codeplug/presentation/providers/codeplug_provider.dart';
import '../../data/services/local_cache_service.dart';
import '../../data/services/api_service.dart';
import '../providers/auth_provider.dart';
import '../providers/connectivity_provider.dart';
import '../providers/offline_sync_provider.dart';
import 'login_screen.dart';

class CloudScreen extends ConsumerStatefulWidget {
  const CloudScreen({super.key});

  @override
  ConsumerState<CloudScreen> createState() => _CloudScreenState();
}

class _CloudScreenState extends ConsumerState<CloudScreen> {
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    // Initial sync when authenticated and online
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryInitialSync();
    });
  }

  Future<void> _tryInitialSync() async {
    final isOnline = ref.read(isOnlineProvider);
    final isAuthenticated = ref.read(authProvider).isAuthenticated;

    if (isOnline && isAuthenticated) {
      await ref.read(offlineSyncProvider.notifier).refresh();
      ref.invalidate(cachedCodeplugsProvider);
    }
  }

  Future<void> _saveToCloud() async {
    final l10n = L10n.of(context)!;
    final codeplug = ref.read(codeplugNotifierProvider);
    if (codeplug == null) return;

    setState(() => _isSyncing = true);

    try {
      final syncService = ref.read(offlineSyncServiceProvider);
      await syncService.saveCodeplug(
        name: codeplug.name,
        codeplug: codeplug,
      );

      // Try to sync immediately if online
      final isOnline = ref.read(isOnlineProvider);
      if (isOnline) {
        await ref.read(offlineSyncProvider.notifier).sync();
      }

      ref.invalidate(cachedCodeplugsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isOnline ? l10n.cloudSyncSuccess : l10n.cloudSavedOffline,
            ),
          ),
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

  Future<void> _loadFromCache(CachedCodeplug cached) async {
    final l10n = L10n.of(context)!;

    ref.read(codeplugNotifierProvider.notifier).load(cached.codeplug);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cloudSyncSuccess)),
      );
    }
  }

  Future<void> _deleteFromCache(CachedCodeplug cached) async {
    final l10n = L10n.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cloudDelete),
        content: Text(l10n.cloudDeleteConfirm(cached.name)),
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
      final syncService = ref.read(offlineSyncServiceProvider);
      await syncService.deleteCodeplug(cached.id);

      // Try to sync immediately if online
      final isOnline = ref.read(isOnlineProvider);
      if (isOnline && cached.cloudId != null) {
        await ref.read(offlineSyncProvider.notifier).sync();
      }

      ref.invalidate(cachedCodeplugsProvider);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.cloudSyncError}: ${e.message}')),
        );
      }
    }
  }

  Future<void> _syncNow() async {
    final l10n = L10n.of(context)!;
    final result = await ref.read(offlineSyncProvider.notifier).sync();

    if (result != null && mounted) {
      ref.invalidate(cachedCodeplugsProvider);

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.cloudSyncSuccess)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.cloudSyncError}: ${result.errors.join(', ')}'),
          ),
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
    final isOnline = ref.watch(isOnlineProvider);
    final syncState = ref.watch(offlineSyncProvider);

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

    // Logged in - show codeplugs (from cache)
    final cachedCodeplugsAsync = ref.watch(cachedCodeplugsProvider);

    return Column(
      children: [
        // Offline banner
        if (!isOnline)
          Container(
            width: double.infinity,
            color: theme.colorScheme.tertiaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.cloud_off,
                  size: 16,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.cloudOfflineMode,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
                if (syncState.pendingCount > 0)
                  Chip(
                    label: Text(
                      l10n.cloudPendingSync(syncState.pendingCount),
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: theme.colorScheme.tertiary,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onTertiary,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),

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
              // Sync button with pending indicator
              Stack(
                children: [
                  IconButton(
                    onPressed: syncState.isSyncing || !isOnline
                        ? null
                        : _syncNow,
                    icon: syncState.isSyncing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.sync),
                    tooltip: l10n.cloudSyncNow,
                  ),
                  if (syncState.pendingCount > 0 && !syncState.isSyncing)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${syncState.pendingCount}',
                          style: TextStyle(
                            color: theme.colorScheme.onError,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
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

        // Codeplugs list (from local cache)
        Expanded(
          child: cachedCodeplugsAsync.when(
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
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Icon(
                              Icons.settings_input_antenna,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          // Pending sync indicator
                          if (item.pendingSync)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.sync,
                                  size: 12,
                                  color: theme.colorScheme.onTertiary,
                                ),
                              ),
                            ),
                          // Cloud synced indicator
                          if (!item.pendingSync && item.cloudId != null)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.cloud_done,
                                  size: 12,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(item.name),
                      subtitle: Row(
                        children: [
                          Text(
                            l10n.cloudLastSync(dateFormat.format(item.updatedAt)),
                            style: theme.textTheme.bodySmall,
                          ),
                          if (item.pendingSync) ...[
                            const SizedBox(width: 8),
                            Text(
                              '• ${l10n.cloudPendingLabel}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.download),
                            tooltip: l10n.cloudLoadFromCloud,
                            onPressed:
                                _isSyncing ? null : () => _loadFromCache(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: l10n.cloudDelete,
                            onPressed: () => _deleteFromCache(item),
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
                    onPressed: () => ref.invalidate(cachedCodeplugsProvider),
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
