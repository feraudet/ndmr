// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dirty_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hasUnsavedChangesHash() => r'fea7df9ce8605f5446cf0ff8e6ae0f5c32719b51';

/// Provider for checking if there are unsaved changes
///
/// Copied from [hasUnsavedChanges].
@ProviderFor(hasUnsavedChanges)
final hasUnsavedChangesProvider = AutoDisposeProvider<bool>.internal(
  hasUnsavedChanges,
  name: r'hasUnsavedChangesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasUnsavedChangesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasUnsavedChangesRef = AutoDisposeProviderRef<bool>;
String _$dirtyStateNotifierHash() =>
    r'65b27c329e3770322cc7e0bd109e68fa76643ceb';

/// Tracks whether the codeplug has unsaved changes
///
/// Copied from [DirtyStateNotifier].
@ProviderFor(DirtyStateNotifier)
final dirtyStateNotifierProvider =
    AutoDisposeNotifierProvider<DirtyStateNotifier, bool>.internal(
      DirtyStateNotifier.new,
      name: r'dirtyStateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dirtyStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DirtyStateNotifier = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
