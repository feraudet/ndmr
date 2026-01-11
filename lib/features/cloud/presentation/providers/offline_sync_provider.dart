import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/local_cache_service.dart';
import '../../data/services/offline_sync_service.dart';
import 'auth_provider.dart';
import 'connectivity_provider.dart';

/// State for offline sync operations
class OfflineSyncState {
  final bool isSyncing;
  final int pendingCount;
  final String? lastError;
  final DateTime? lastSyncTime;

  const OfflineSyncState({
    this.isSyncing = false,
    this.pendingCount = 0,
    this.lastError,
    this.lastSyncTime,
  });

  OfflineSyncState copyWith({
    bool? isSyncing,
    int? pendingCount,
    String? lastError,
    DateTime? lastSyncTime,
  }) {
    return OfflineSyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      pendingCount: pendingCount ?? this.pendingCount,
      lastError: lastError,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

class OfflineSyncNotifier extends StateNotifier<OfflineSyncState> {
  final OfflineSyncService _syncService;
  final Ref _ref;

  OfflineSyncNotifier(this._syncService, this._ref)
      : super(const OfflineSyncState()) {
    _init();
  }

  Future<void> _init() async {
    await _updatePendingCount();
  }

  Future<void> _updatePendingCount() async {
    final count = await _syncService.getPendingCount();
    state = state.copyWith(pendingCount: count);
  }

  /// Sync all pending changes (if online and authenticated)
  Future<SyncResult?> sync() async {
    final isOnline = _ref.read(isOnlineProvider);
    final isAuthenticated = _ref.read(authProvider).isAuthenticated;

    if (!isOnline || !isAuthenticated) {
      return null;
    }

    state = state.copyWith(isSyncing: true, lastError: null);

    try {
      final result = await _syncService.fullSync();
      await _updatePendingCount();

      state = state.copyWith(
        isSyncing: false,
        lastSyncTime: DateTime.now(),
        lastError: result.success ? null : result.errors.join(', '),
      );

      return result;
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        lastError: e.toString(),
      );
      return SyncResult(
        success: false,
        errors: [e.toString()],
      );
    }
  }

  /// Refresh from cloud (pull only)
  Future<void> refresh() async {
    final isOnline = _ref.read(isOnlineProvider);
    final isAuthenticated = _ref.read(authProvider).isAuthenticated;

    if (!isOnline || !isAuthenticated) {
      return;
    }

    state = state.copyWith(isSyncing: true, lastError: null);

    try {
      await _syncService.refreshFromCloud();
      await _updatePendingCount();

      state = state.copyWith(
        isSyncing: false,
        lastSyncTime: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        lastError: e.toString(),
      );
    }
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await _syncService.clearCache();
    state = const OfflineSyncState();
  }
}

final offlineSyncServiceProvider = Provider<OfflineSyncService>((ref) {
  return OfflineSyncService();
});

final offlineSyncProvider =
    StateNotifierProvider<OfflineSyncNotifier, OfflineSyncState>((ref) {
  return OfflineSyncNotifier(
    ref.watch(offlineSyncServiceProvider),
    ref,
  );
});

/// Provider for cached codeplugs list
final cachedCodeplugsProvider =
    FutureProvider<List<CachedCodeplug>>((ref) async {
  final syncService = ref.watch(offlineSyncServiceProvider);
  return syncService.getAllCodeplugs();
});
