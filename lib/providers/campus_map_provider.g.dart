// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campus_map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$campusMapDetailsHash() => r'd97cb5054dca2c8b9459834165e10b97e2ae0c41';

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

/// See also [campusMapDetails].
@ProviderFor(campusMapDetails)
const campusMapDetailsProvider = CampusMapDetailsFamily();

/// See also [campusMapDetails].
class CampusMapDetailsFamily extends Family<AsyncValue<CampusMapModel>> {
  /// See also [campusMapDetails].
  const CampusMapDetailsFamily();

  /// See also [campusMapDetails].
  CampusMapDetailsProvider call(
    int mapId,
  ) {
    return CampusMapDetailsProvider(
      mapId,
    );
  }

  @override
  CampusMapDetailsProvider getProviderOverride(
    covariant CampusMapDetailsProvider provider,
  ) {
    return call(
      provider.mapId,
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
  String? get name => r'campusMapDetailsProvider';
}

/// See also [campusMapDetails].
class CampusMapDetailsProvider
    extends AutoDisposeFutureProvider<CampusMapModel> {
  /// See also [campusMapDetails].
  CampusMapDetailsProvider(
    int mapId,
  ) : this._internal(
          (ref) => campusMapDetails(
            ref as CampusMapDetailsRef,
            mapId,
          ),
          from: campusMapDetailsProvider,
          name: r'campusMapDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$campusMapDetailsHash,
          dependencies: CampusMapDetailsFamily._dependencies,
          allTransitiveDependencies:
              CampusMapDetailsFamily._allTransitiveDependencies,
          mapId: mapId,
        );

  CampusMapDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mapId,
  }) : super.internal();

  final int mapId;

  @override
  Override overrideWith(
    FutureOr<CampusMapModel> Function(CampusMapDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CampusMapDetailsProvider._internal(
        (ref) => create(ref as CampusMapDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mapId: mapId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CampusMapModel> createElement() {
    return _CampusMapDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CampusMapDetailsProvider && other.mapId == mapId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mapId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CampusMapDetailsRef on AutoDisposeFutureProviderRef<CampusMapModel> {
  /// The parameter `mapId` of this provider.
  int get mapId;
}

class _CampusMapDetailsProviderElement
    extends AutoDisposeFutureProviderElement<CampusMapModel>
    with CampusMapDetailsRef {
  _CampusMapDetailsProviderElement(super.provider);

  @override
  int get mapId => (origin as CampusMapDetailsProvider).mapId;
}

String _$campusMapNotifierHash() => r'e1a1fb8e50c10208d5621a7ca6ab8f9077796e94';

/// See also [CampusMapNotifier].
@ProviderFor(CampusMapNotifier)
final campusMapNotifierProvider = AutoDisposeNotifierProvider<CampusMapNotifier,
    List<CampusMapModel>>.internal(
  CampusMapNotifier.new,
  name: r'campusMapNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$campusMapNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CampusMapNotifier = AutoDisposeNotifier<List<CampusMapModel>>;
String _$campusMapAutoRefreshHash() =>
    r'5a98c07186583acb2b68bc592b4b6628ec13b80c';

abstract class _$CampusMapAutoRefresh
    extends BuildlessAutoDisposeStreamNotifier<List<CampusMapModel>> {
  late final String url;

  Stream<List<CampusMapModel>> build(
    String url,
  );
}

/// See also [CampusMapAutoRefresh].
@ProviderFor(CampusMapAutoRefresh)
const campusMapAutoRefreshProvider = CampusMapAutoRefreshFamily();

/// See also [CampusMapAutoRefresh].
class CampusMapAutoRefreshFamily
    extends Family<AsyncValue<List<CampusMapModel>>> {
  /// See also [CampusMapAutoRefresh].
  const CampusMapAutoRefreshFamily();

  /// See also [CampusMapAutoRefresh].
  CampusMapAutoRefreshProvider call(
    String url,
  ) {
    return CampusMapAutoRefreshProvider(
      url,
    );
  }

  @override
  CampusMapAutoRefreshProvider getProviderOverride(
    covariant CampusMapAutoRefreshProvider provider,
  ) {
    return call(
      provider.url,
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
  String? get name => r'campusMapAutoRefreshProvider';
}

/// See also [CampusMapAutoRefresh].
class CampusMapAutoRefreshProvider
    extends AutoDisposeStreamNotifierProviderImpl<CampusMapAutoRefresh,
        List<CampusMapModel>> {
  /// See also [CampusMapAutoRefresh].
  CampusMapAutoRefreshProvider(
    String url,
  ) : this._internal(
          () => CampusMapAutoRefresh()..url = url,
          from: campusMapAutoRefreshProvider,
          name: r'campusMapAutoRefreshProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$campusMapAutoRefreshHash,
          dependencies: CampusMapAutoRefreshFamily._dependencies,
          allTransitiveDependencies:
              CampusMapAutoRefreshFamily._allTransitiveDependencies,
          url: url,
        );

  CampusMapAutoRefreshProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
  }) : super.internal();

  final String url;

  @override
  Stream<List<CampusMapModel>> runNotifierBuild(
    covariant CampusMapAutoRefresh notifier,
  ) {
    return notifier.build(
      url,
    );
  }

  @override
  Override overrideWith(CampusMapAutoRefresh Function() create) {
    return ProviderOverride(
      origin: this,
      override: CampusMapAutoRefreshProvider._internal(
        () => create()..url = url,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<CampusMapAutoRefresh,
      List<CampusMapModel>> createElement() {
    return _CampusMapAutoRefreshProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CampusMapAutoRefreshProvider && other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CampusMapAutoRefreshRef
    on AutoDisposeStreamNotifierProviderRef<List<CampusMapModel>> {
  /// The parameter `url` of this provider.
  String get url;
}

class _CampusMapAutoRefreshProviderElement
    extends AutoDisposeStreamNotifierProviderElement<CampusMapAutoRefresh,
        List<CampusMapModel>> with CampusMapAutoRefreshRef {
  _CampusMapAutoRefreshProviderElement(super.provider);

  @override
  String get url => (origin as CampusMapAutoRefreshProvider).url;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
