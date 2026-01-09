// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$canUndoHash() => r'8548538398bc740381c6bd4853360661cc16cc75';

/// Provider for checking if undo is available
///
/// Copied from [canUndo].
@ProviderFor(canUndo)
final canUndoProvider = AutoDisposeProvider<bool>.internal(
  canUndo,
  name: r'canUndoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$canUndoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanUndoRef = AutoDisposeProviderRef<bool>;
String _$canRedoHash() => r'3a10a9b5339f5ee89e06758d263a0368670b99a1';

/// Provider for checking if redo is available
///
/// Copied from [canRedo].
@ProviderFor(canRedo)
final canRedoProvider = AutoDisposeProvider<bool>.internal(
  canRedo,
  name: r'canRedoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$canRedoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanRedoRef = AutoDisposeProviderRef<bool>;
String _$historyNotifierHash() => r'3aa8c5217f687fb9cb23acc5584c6156eef20129';

/// See also [HistoryNotifier].
@ProviderFor(HistoryNotifier)
final historyNotifierProvider =
    AutoDisposeNotifierProvider<HistoryNotifier, void>.internal(
      HistoryNotifier.new,
      name: r'historyNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$historyNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HistoryNotifier = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
