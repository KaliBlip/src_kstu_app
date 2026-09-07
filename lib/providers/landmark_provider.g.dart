// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landmark_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$landmarkPlacesHash() => r'02e63dd01d8fd7931cdadfc670c5c0e7bdea6d95';

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

/// See also [landmarkPlaces].
@ProviderFor(landmarkPlaces)
const landmarkPlacesProvider = LandmarkPlacesFamily();

/// See also [landmarkPlaces].
class LandmarkPlacesFamily extends Family<AsyncValue<List<LandmarkModel>>> {
  /// See also [landmarkPlaces].
  const LandmarkPlacesFamily();

  /// See also [landmarkPlaces].
  LandmarkPlacesProvider call(
    int trendId,
  ) {
    return LandmarkPlacesProvider(
      trendId,
    );
  }

  @override
  LandmarkPlacesProvider getProviderOverride(
    covariant LandmarkPlacesProvider provider,
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
  String? get name => r'landmarkPlacesProvider';
}

/// See also [landmarkPlaces].
class LandmarkPlacesProvider
    extends AutoDisposeFutureProvider<List<LandmarkModel>> {
  /// See also [landmarkPlaces].
  LandmarkPlacesProvider(
    int trendId,
  ) : this._internal(
          (ref) => landmarkPlaces(
            ref as LandmarkPlacesRef,
            trendId,
          ),
          from: landmarkPlacesProvider,
          name: r'landmarkPlacesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$landmarkPlacesHash,
          dependencies: LandmarkPlacesFamily._dependencies,
          allTransitiveDependencies:
              LandmarkPlacesFamily._allTransitiveDependencies,
          trendId: trendId,
        );

  LandmarkPlacesProvider._internal(
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
    FutureOr<List<LandmarkModel>> Function(LandmarkPlacesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LandmarkPlacesProvider._internal(
        (ref) => create(ref as LandmarkPlacesRef),
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
  AutoDisposeFutureProviderElement<List<LandmarkModel>> createElement() {
    return _LandmarkPlacesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LandmarkPlacesProvider && other.trendId == trendId;
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
mixin LandmarkPlacesRef on AutoDisposeFutureProviderRef<List<LandmarkModel>> {
  /// The parameter `trendId` of this provider.
  int get trendId;
}

class _LandmarkPlacesProviderElement
    extends AutoDisposeFutureProviderElement<List<LandmarkModel>>
    with LandmarkPlacesRef {
  _LandmarkPlacesProviderElement(super.provider);

  @override
  int get trendId => (origin as LandmarkPlacesProvider).trendId;
}

String _$landmarkNotifierHash() => r'a97ed925d7d3400dd121a6023b019800e7e0c4c5';

/// See also [LandmarkNotifier].
@ProviderFor(LandmarkNotifier)
final landmarkNotifierProvider =
    AutoDisposeNotifierProvider<LandmarkNotifier, List<LandmarkModel>>.internal(
  LandmarkNotifier.new,
  name: r'landmarkNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$landmarkNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LandmarkNotifier = AutoDisposeNotifier<List<LandmarkModel>>;
String _$landmarkAutoRefreshHash() =>
    r'054e01325558faa131c500faed0f7d88a42f733c';

abstract class _$LandmarkAutoRefresh
    extends BuildlessAutoDisposeStreamNotifier<List<LandmarkModel>> {
  late final int trendId;

  Stream<List<LandmarkModel>> build(
    int trendId,
  );
}

/// See also [LandmarkAutoRefresh].
@ProviderFor(LandmarkAutoRefresh)
const landmarkAutoRefreshProvider = LandmarkAutoRefreshFamily();

/// See also [LandmarkAutoRefresh].
class LandmarkAutoRefreshFamily
    extends Family<AsyncValue<List<LandmarkModel>>> {
  /// See also [LandmarkAutoRefresh].
  const LandmarkAutoRefreshFamily();

  /// See also [LandmarkAutoRefresh].
  LandmarkAutoRefreshProvider call(
    int trendId,
  ) {
    return LandmarkAutoRefreshProvider(
      trendId,
    );
  }

  @override
  LandmarkAutoRefreshProvider getProviderOverride(
    covariant LandmarkAutoRefreshProvider provider,
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
  String? get name => r'landmarkAutoRefreshProvider';
}

/// See also [LandmarkAutoRefresh].
class LandmarkAutoRefreshProvider extends AutoDisposeStreamNotifierProviderImpl<
    LandmarkAutoRefresh, List<LandmarkModel>> {
  /// See also [LandmarkAutoRefresh].
  LandmarkAutoRefreshProvider(
    int trendId,
  ) : this._internal(
          () => LandmarkAutoRefresh()..trendId = trendId,
          from: landmarkAutoRefreshProvider,
          name: r'landmarkAutoRefreshProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$landmarkAutoRefreshHash,
          dependencies: LandmarkAutoRefreshFamily._dependencies,
          allTransitiveDependencies:
              LandmarkAutoRefreshFamily._allTransitiveDependencies,
          trendId: trendId,
        );

  LandmarkAutoRefreshProvider._internal(
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
  Stream<List<LandmarkModel>> runNotifierBuild(
    covariant LandmarkAutoRefresh notifier,
  ) {
    return notifier.build(
      trendId,
    );
  }

  @override
  Override overrideWith(LandmarkAutoRefresh Function() create) {
    return ProviderOverride(
      origin: this,
      override: LandmarkAutoRefreshProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<LandmarkAutoRefresh,
      List<LandmarkModel>> createElement() {
    return _LandmarkAutoRefreshProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LandmarkAutoRefreshProvider && other.trendId == trendId;
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
mixin LandmarkAutoRefreshRef
    on AutoDisposeStreamNotifierProviderRef<List<LandmarkModel>> {
  /// The parameter `trendId` of this provider.
  int get trendId;
}

class _LandmarkAutoRefreshProviderElement
    extends AutoDisposeStreamNotifierProviderElement<LandmarkAutoRefresh,
        List<LandmarkModel>> with LandmarkAutoRefreshRef {
  _LandmarkAutoRefreshProviderElement(super.provider);

  @override
  int get trendId => (origin as LandmarkAutoRefreshProvider).trendId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
