// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_moments_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$keyMomentsHash() => r'ef96808b97a863e76ccc2c191b7681ce69f4dd58';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [keyMoments].
@ProviderFor(keyMoments)
const keyMomentsProvider = KeyMomentsFamily();

/// See also [keyMoments].
class KeyMomentsFamily
    extends Family<AsyncValue<List<AnnouncementKeyMoments>>> {
  /// See also [keyMoments].
  const KeyMomentsFamily();

  /// See also [keyMoments].
  KeyMomentsProvider call(
    int trendId,
  ) {
    return KeyMomentsProvider(
      trendId,
    );
  }

  @override
  KeyMomentsProvider getProviderOverride(
    covariant KeyMomentsProvider provider,
  ) {
    return call(
      provider.trendId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'keyMomentsProvider';
}

/// See also [keyMoments].
class KeyMomentsProvider
    extends AutoDisposeFutureProvider<List<AnnouncementKeyMoments>> {
  /// See also [keyMoments].
  KeyMomentsProvider(
    int trendId,
  ) : this._internal(
          (ref) => keyMoments(
            ref as KeyMomentsRef,
            trendId,
          ),
          from: keyMomentsProvider,
          name: r'keyMomentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$keyMomentsHash,
          dependencies: KeyMomentsFamily._dependencies,
          allTransitiveDependencies:
              KeyMomentsFamily._allTransitiveDependencies,
          trendId: trendId,
        );

  KeyMomentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.trendId,
  }) : super.internal();

  final int trendId;

  @override
  Override overrideWith(
    FutureOr<List<AnnouncementKeyMoments>> Function(KeyMomentsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: KeyMomentsProvider._internal(
        (ref) => create(ref as KeyMomentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        trendId: trendId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AnnouncementKeyMoments>>
      createElement() {
    return _KeyMomentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is KeyMomentsProvider && other.trendId == trendId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, trendId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin KeyMomentsRef
    on AutoDisposeFutureProviderRef<List<AnnouncementKeyMoments>> {
  /// The parameter `trendId` of this provider.
  int get trendId;
}

class _KeyMomentsProviderElement
    extends AutoDisposeFutureProviderElement<List<AnnouncementKeyMoments>>
    with KeyMomentsRef {
  _KeyMomentsProviderElement(super.provider);

  @override
  int get trendId => (origin as KeyMomentsProvider).trendId;
}

String _$keyMomentsNotifierHash() =>
    r'86afa7c26dfcf05aa510b0baeb40015b84bb55c2';

/// See also [KeyMomentsNotifier].
@ProviderFor(KeyMomentsNotifier)
final keyMomentsNotifierProvider = AutoDisposeNotifierProvider<
    KeyMomentsNotifier, List<AnnouncementKeyMoments>>.internal(
  KeyMomentsNotifier.new,
  name: r'keyMomentsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$keyMomentsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$KeyMomentsNotifier
    = AutoDisposeNotifier<List<AnnouncementKeyMoments>>;
String _$keyMomentsAutoRefreshHash() =>
    r'c6efa9ec60630048712c772e0f2bee72f3535225';

abstract class _$KeyMomentsAutoRefresh
    extends BuildlessAutoDisposeStreamNotifier<List<AnnouncementKeyMoments>> {
  late final int trendId;

  Stream<List<AnnouncementKeyMoments>> build(
    int trendId,
  );
}

/// See also [KeyMomentsAutoRefresh].
@ProviderFor(KeyMomentsAutoRefresh)
const keyMomentsAutoRefreshProvider = KeyMomentsAutoRefreshFamily();

/// See also [KeyMomentsAutoRefresh].
class KeyMomentsAutoRefreshFamily
    extends Family<AsyncValue<List<AnnouncementKeyMoments>>> {
  /// See also [KeyMomentsAutoRefresh].
  const KeyMomentsAutoRefreshFamily();

  /// See also [KeyMomentsAutoRefresh].
  KeyMomentsAutoRefreshProvider call(
    int trendId,
  ) {
    return KeyMomentsAutoRefreshProvider(
      trendId,
    );
  }

  @override
  KeyMomentsAutoRefreshProvider getProviderOverride(
    covariant KeyMomentsAutoRefreshProvider provider,
  ) {
    return call(
      provider.trendId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'keyMomentsAutoRefreshProvider';
}

/// See also [KeyMomentsAutoRefresh].
class KeyMomentsAutoRefreshProvider
    extends AutoDisposeStreamNotifierProviderImpl<KeyMomentsAutoRefresh,
        List<AnnouncementKeyMoments>> {
  /// See also [KeyMomentsAutoRefresh].
  KeyMomentsAutoRefreshProvider(
    int trendId,
  ) : this._internal(
          () => KeyMomentsAutoRefresh()..trendId = trendId,
          from: keyMomentsAutoRefreshProvider,
          name: r'keyMomentsAutoRefreshProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$keyMomentsAutoRefreshHash,
          dependencies: KeyMomentsAutoRefreshFamily._dependencies,
          allTransitiveDependencies:
              KeyMomentsAutoRefreshFamily._allTransitiveDependencies,
          trendId: trendId,
        );

  KeyMomentsAutoRefreshProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.trendId,
  }) : super.internal();

  final int trendId;

  @override
  Stream<List<AnnouncementKeyMoments>> runNotifierBuild(
    covariant KeyMomentsAutoRefresh notifier,
  ) {
    return notifier.build(
      trendId,
    );
  }

  @override
  Override overrideWith(KeyMomentsAutoRefresh Function() create) {
    return ProviderOverride(
      origin: this,
      override: KeyMomentsAutoRefreshProvider._internal(
        () => create()..trendId = trendId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        trendId: trendId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<KeyMomentsAutoRefresh,
      List<AnnouncementKeyMoments>> createElement() {
    return _KeyMomentsAutoRefreshProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is KeyMomentsAutoRefreshProvider && other.trendId == trendId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, trendId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin KeyMomentsAutoRefreshRef
    on AutoDisposeStreamNotifierProviderRef<List<AnnouncementKeyMoments>> {
  /// The parameter `trendId` of this provider.
  int get trendId;
}

class _KeyMomentsAutoRefreshProviderElement
    extends AutoDisposeStreamNotifierProviderElement<KeyMomentsAutoRefresh,
        List<AnnouncementKeyMoments>> with KeyMomentsAutoRefreshRef {
  _KeyMomentsAutoRefreshProviderElement(super.provider);

  @override
  int get trendId => (origin as KeyMomentsAutoRefreshProvider).trendId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
