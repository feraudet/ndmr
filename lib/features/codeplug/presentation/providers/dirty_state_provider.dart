import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/models.dart';
import 'codeplug_provider.dart';

part 'dirty_state_provider.g.dart';

/// Tracks whether the codeplug has unsaved changes
@riverpod
class DirtyStateNotifier extends _$DirtyStateNotifier {
  Codeplug? _lastSavedState;

  @override
  bool build() {
    // Listen to codeplug changes
    ref.listen(codeplugNotifierProvider, (previous, next) {
      // If codeplug becomes null (closed), reset dirty state
      if (next == null) {
        _lastSavedState = null;
        state = false;
        return;
      }

      // Check if current state differs from last saved
      state = _lastSavedState == null || next != _lastSavedState;
    });

    return false;
  }

  /// Mark the current state as saved
  void markAsSaved() {
    _lastSavedState = ref.read(codeplugNotifierProvider);
    state = false;
  }

  /// Mark as dirty (for new codeplugs)
  void markAsDirty() {
    state = true;
  }

  /// Set the initial saved state (when loading a file)
  void setInitialState(Codeplug codeplug) {
    _lastSavedState = codeplug;
    state = false;
  }
}

/// Provider for checking if there are unsaved changes
@riverpod
bool hasUnsavedChanges(Ref ref) {
  return ref.watch(dirtyStateNotifierProvider);
}
