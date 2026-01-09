import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/models.dart';
import 'codeplug_provider.dart';

part 'history_provider.g.dart';

/// Maximum number of undo steps to keep
const _maxHistorySize = 50;

@riverpod
class HistoryNotifier extends _$HistoryNotifier {
  final List<Codeplug> _undoStack = [];
  final List<Codeplug> _redoStack = [];

  @override
  void build() {
    // Listen to codeplug changes to record history
    ref.listen(codeplugNotifierProvider, (previous, next) {
      if (previous != null && next != null && previous != next) {
        // Don't record if this is an undo/redo operation
        if (!_isUndoRedoOperation) {
          _pushToUndo(previous);
          _redoStack.clear();
        }
      }
    });
  }

  bool _isUndoRedoOperation = false;

  void _pushToUndo(Codeplug codeplug) {
    _undoStack.add(codeplug);
    if (_undoStack.length > _maxHistorySize) {
      _undoStack.removeAt(0);
    }
  }

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void undo() {
    if (!canUndo) return;

    final current = ref.read(codeplugNotifierProvider);
    if (current == null) return;

    final previous = _undoStack.removeLast();
    _redoStack.add(current);

    _isUndoRedoOperation = true;
    ref.read(codeplugNotifierProvider.notifier).load(previous);
    _isUndoRedoOperation = false;
  }

  void redo() {
    if (!canRedo) return;

    final current = ref.read(codeplugNotifierProvider);
    if (current == null) return;

    final next = _redoStack.removeLast();
    _undoStack.add(current);

    _isUndoRedoOperation = true;
    ref.read(codeplugNotifierProvider.notifier).load(next);
    _isUndoRedoOperation = false;
  }

  void clearHistory() {
    _undoStack.clear();
    _redoStack.clear();
  }
}

/// Provider for checking if undo is available
@riverpod
bool canUndo(Ref ref) {
  ref.watch(historyNotifierProvider);
  // Force rebuild on codeplug changes
  ref.watch(codeplugNotifierProvider);
  return ref.read(historyNotifierProvider.notifier).canUndo;
}

/// Provider for checking if redo is available
@riverpod
bool canRedo(Ref ref) {
  ref.watch(historyNotifierProvider);
  // Force rebuild on codeplug changes
  ref.watch(codeplugNotifierProvider);
  return ref.read(historyNotifierProvider.notifier).canRedo;
}
