// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectivityStreamHash() =>
    r'777edd970655c8946ffc0ce4ea92ff9e8f18bbf7';

/// See also [connectivityStream].
@ProviderFor(connectivityStream)
final connectivityStreamProvider =
    AutoDisposeStreamProvider<ConnectivityStatus>.internal(
  connectivityStream,
  name: r'connectivityStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectivityStreamRef
    = AutoDisposeStreamProviderRef<ConnectivityStatus>;
String _$connectivityNotifierHash() =>
    r'febae6b39dc3da83c0fd6130a320cd9c42df1339';

/// See also [ConnectivityNotifier].
@ProviderFor(ConnectivityNotifier)
final connectivityNotifierProvider = AutoDisposeNotifierProvider<
    ConnectivityNotifier, ConnectivityStatus>.internal(
  ConnectivityNotifier.new,
  name: r'connectivityNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConnectivityNotifier = AutoDisposeNotifier<ConnectivityStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
