import 'package:uuid/uuid.dart';

import '../../../codeplug/data/models/models.dart';
import 'api_service.dart';
import 'local_cache_service.dart';
import 'sync_service.dart';

const _uuid = Uuid();

/// Result of a sync operation
class SyncResult {
  final bool success;
  final int syncedCount;
  final int failedCount;
  final List<String> errors;

  SyncResult({
    required this.success,
    this.syncedCount = 0,
    this.failedCount = 0,
    this.errors = const [],
  });
}

/// Offline-first sync service
/// Handles local caching and background synchronization
class OfflineSyncService {
  final LocalCacheService _cache;
  final SyncService _syncService;
  final ApiService _api;

  OfflineSyncService({
    LocalCacheService? cache,
    SyncService? syncService,
    ApiService? api,
  })  : _cache = cache ?? LocalCacheService(),
        _syncService = syncService ?? SyncService(),
        _api = api ?? ApiService();

  /// Get all codeplugs (from cache, offline-first)
  Future<List<CachedCodeplug>> getAllCodeplugs() async {
    return _cache.getAllCached();
  }

  /// Get a codeplug by ID (local or cloud)
  Future<CachedCodeplug?> getCodeplug(String id) async {
    // Try local cache first
    var cached = await _cache.getById(id);
    if (cached != null) return cached;

    // Try by cloud ID
    cached = await _cache.getByCloudId(id);
    return cached;
  }

  /// Save a codeplug locally (will be synced when online)
  Future<CachedCodeplug> saveCodeplug({
    String? id,
    String? cloudId,
    required String name,
    required Codeplug codeplug,
    int version = 0,
  }) async {
    final localId = id ?? _uuid.v4();
    final isNew = id == null && cloudId == null;

    final cached = CachedCodeplug(
      id: localId,
      cloudId: cloudId,
      name: name,
      codeplug: codeplug,
      version: version,
      updatedAt: DateTime.now(),
      pendingSync: true,
      pendingAction: isNew ? SyncAction.create : SyncAction.update,
    );

    await _cache.save(cached);
    return cached;
  }

  /// Delete a codeplug (marks for deletion, synced when online)
  Future<void> deleteCodeplug(String id) async {
    final cached = await _cache.getById(id);
    if (cached == null) return;

    if (cached.cloudId != null) {
      // Has cloud version - mark for deletion sync
      await _cache.markPendingSync(id, SyncAction.delete);
    } else {
      // Only local - just delete
      await _cache.delete(id);
    }
  }

  /// Sync all pending changes with the cloud
  Future<SyncResult> syncPending() async {
    final pending = await _cache.getPendingSync();
    if (pending.isEmpty) {
      return SyncResult(success: true);
    }

    int syncedCount = 0;
    int failedCount = 0;
    final errors = <String>[];

    for (final item in pending) {
      try {
        switch (item.pendingAction) {
          case SyncAction.create:
            final cloudCodeplug = await _syncService.createCodeplug(
              name: item.name,
              codeplug: item.codeplug,
            );
            await _cache.markSynced(
              item.id,
              cloudId: cloudCodeplug.id,
              version: cloudCodeplug.version,
            );
            syncedCount++;
            break;

          case SyncAction.update:
            if (item.cloudId != null) {
              final cloudCodeplug = await _syncService.updateCodeplug(
                id: item.cloudId!,
                name: item.name,
                codeplug: item.codeplug,
              );
              await _cache.markSynced(
                item.id,
                version: cloudCodeplug.version,
              );
              syncedCount++;
            }
            break;

          case SyncAction.delete:
            if (item.cloudId != null) {
              await _syncService.deleteCodeplug(item.cloudId!);
            }
            await _cache.delete(item.id);
            syncedCount++;
            break;

          case null:
            break;
        }
      } on ApiException catch (e) {
        failedCount++;
        errors.add('${item.name}: ${e.message}');
      } catch (e) {
        failedCount++;
        errors.add('${item.name}: $e');
      }
    }

    return SyncResult(
      success: failedCount == 0,
      syncedCount: syncedCount,
      failedCount: failedCount,
      errors: errors,
    );
  }

  /// Fetch codeplugs from cloud and update local cache
  Future<void> refreshFromCloud() async {
    try {
      final cloudList = await _syncService.listCodeplugs();

      for (final item in cloudList) {
        // Check if we have a local version
        final local = await _cache.getByCloudId(item.id);

        // Skip if local has pending changes (don't overwrite)
        if (local != null && local.pendingSync) {
          continue;
        }

        // Fetch full codeplug if new or updated
        if (local == null || local.version < item.version) {
          final cloudCodeplug = await _syncService.getCodeplug(item.id);
          final cached = CachedCodeplug(
            id: local?.id ?? _uuid.v4(),
            cloudId: cloudCodeplug.id,
            name: cloudCodeplug.name,
            codeplug: cloudCodeplug.toCodeplug(),
            version: cloudCodeplug.version,
            updatedAt: cloudCodeplug.updatedAt,
            pendingSync: false,
          );
          await _cache.save(cached);
        }
      }

      // Remove local cached items that were deleted from cloud
      // (only if they don't have pending changes)
      final allCached = await _cache.getAllCached();
      final cloudIds = cloudList.map((c) => c.id).toSet();

      for (final cached in allCached) {
        if (cached.cloudId != null &&
            !cloudIds.contains(cached.cloudId) &&
            !cached.pendingSync) {
          await _cache.delete(cached.id);
        }
      }
    } catch (e) {
      // Offline or error - continue with cached data
      rethrow;
    }
  }

  /// Full sync: push pending changes, then pull from cloud
  Future<SyncResult> fullSync() async {
    // First, push pending changes
    final pushResult = await syncPending();

    // Then, pull from cloud
    try {
      await refreshFromCloud();
    } catch (e) {
      return SyncResult(
        success: false,
        syncedCount: pushResult.syncedCount,
        failedCount: pushResult.failedCount,
        errors: [...pushResult.errors, 'Pull failed: $e'],
      );
    }

    return pushResult;
  }

  /// Get count of pending sync items
  Future<int> getPendingCount() async {
    return _cache.getPendingSyncCount();
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await _cache.clearAll();
  }
}
