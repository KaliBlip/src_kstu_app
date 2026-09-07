// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_news_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trendingNewsDetailsHash() =>
    r'30778f7692273f26c2718163124edabc9fa51786';

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

/// See also [trendingNewsDetails].
@ProviderFor(trendingNewsDetails)
const trendingNewsDetailsProvider = TrendingNewsDetailsFamily();

/// See also [trendingNewsDetails].
class TrendingNewsDetailsFamily extends Family<AsyncValue<Announcement>> {
  /// See also [trendingNewsDetails].
  const TrendingNewsDetailsFamily();

  /// See also [trendingNewsDetails].
  TrendingNewsDetailsProvider call(
    int trendId,
  ) {
    return TrendingNewsDetailsProvider(
      trendId,
    );
  }

  @override
  TrendingNewsDetailsProvider getProviderOverride(
    covariant TrendingNewsDetailsProvider provider,
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
  String? get name => r'trendingNewsDetailsProvider';
}

/// See also [trendingNewsDetails].
class TrendingNewsDetailsProvider
    extends AutoDisposeFutureProvider<Announcement> {
  /// See also [trendingNewsDetails].
  TrendingNewsDetailsProvider(
    int trendId,
  ) : this._internal(
          (ref) => trendingNewsDetails(
            ref as TrendingNewsDetailsRef,
            trendId,
          ),
          from: trendingNewsDetailsProvider,
          name: r'trendingNewsDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trendingNewsDetailsHash,
          dependencies: TrendingNewsDetailsFamily._dependencies,
          allTransitiveDependencies:
              TrendingNewsDetailsFamily._allTransitiveDependencies,
          trendId: trendId,
        );

  TrendingNewsDetailsProvider._internal(
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
    FutureOr<Announcement> Function(TrendingNewsDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TrendingNewsDetailsProvider._internal(
        (ref) => create(ref as TrendingNewsDetailsRef),
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
  AutoDisposeFutureProviderElement<Announcement> createElement() {
    return _TrendingNewsDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrendingNewsDetailsProvider && other.trendId == trendId;
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
mixin TrendingNewsDetailsRef on AutoDisposeFutureProviderRef<Announcement> {
  /// The parameter `trendId` of this provider.
  int get trendId;
}

class _TrendingNewsDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Announcement>
    with TrendingNewsDetailsRef {
  _TrendingNewsDetailsProviderElement(super.provider);

  @override
  int get trendId => (origin as TrendingNewsDetailsProvider).trendId;
}

String _$trendingNewsNotifierHash() =>
    r'429958d6094c30a42b0d9335ef04193eb4995b4e';

/// See also [TrendingNewsNotifier].
@ProviderFor(TrendingNewsNotifier)
final trendingNewsNotifierProvider = AutoDisposeNotifierProvider<
    TrendingNewsNotifier, List<Announcement>>.internal(
  TrendingNewsNotifier.new,
  name: r'trendingNewsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trendingNewsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TrendingNewsNotifier = AutoDisposeNotifier<List<Announcement>>;
String _$trendingNewsAutoRefreshHash() =>
    r'4701c3e822154c391ff6ba225b979866c7f9b0d5';

abstract class _$TrendingNewsAutoRefresh
    extends BuildlessAutoDisposeStreamNotifier<List<Announcement>> {
  late final int pageNumber;

  Stream<List<Announcement>> build(
    int pageNumber,
  );
}

/// See also [TrendingNewsAutoRefresh].
@ProviderFor(TrendingNewsAutoRefresh)
const trendingNewsAutoRefreshProvider = TrendingNewsAutoRefreshFamily();

/// See also [TrendingNewsAutoRefresh].
class TrendingNewsAutoRefreshFamily
    extends Family<AsyncValue<List<Announcement>>> {
  /// See also [TrendingNewsAutoRefresh].
  const TrendingNewsAutoRefreshFamily();

  /// See also [TrendingNewsAutoRefresh].
  TrendingNewsAutoRefreshProvider call(
    int pageNumber,
  ) {
    return TrendingNewsAutoRefreshProvider(
      pageNumber,
    );
  }

  @override
  TrendingNewsAutoRefreshProvider getProviderOverride(
    covariant TrendingNewsAutoRefreshProvider provider,
  ) {
    return call(
      provider.pageNumber,
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
  String? get name => r'trendingNewsAutoRefreshProvider';
}

/// See also [TrendingNewsAutoRefresh].
class TrendingNewsAutoRefreshProvider
    extends AutoDisposeStreamNotifierProviderImpl<TrendingNewsAutoRefresh,
        List<Announcement>> {
  /// See also [TrendingNewsAutoRefresh].
  TrendingNewsAutoRefreshProvider(
    int pageNumber,
  ) : this._internal(
          () => TrendingNewsAutoRefresh()..pageNumber = pageNumber,
          from: trendingNewsAutoRefreshProvider,
          name: r'trendingNewsAutoRefreshProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trendingNewsAutoRefreshHash,
          dependencies: TrendingNewsAutoRefreshFamily._dependencies,
          allTransitiveDependencies:
              TrendingNewsAutoRefreshFamily._allTransitiveDependencies,
          pageNumber: pageNumber,
        );

  TrendingNewsAutoRefreshProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageNumber,
  }) : super.internal();

  final int pageNumber;

  @override
  Stream<List<Announcement>> runNotifierBuild(
    covariant TrendingNewsAutoRefresh notifier,
  ) {
    return notifier.build(
      pageNumber,
    );
  }

  @override
  Override overrideWith(TrendingNewsAutoRefresh Function() create) {
    return ProviderOverride(
      origin: this,
      override: TrendingNewsAutoRefreshProvider._internal(
        () => create()..pageNumber = pageNumber,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageNumber: pageNumber,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<TrendingNewsAutoRefresh,
      List<Announcement>> createElement() {
    return _TrendingNewsAutoRefreshProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrendingNewsAutoRefreshProvider &&
        other.pageNumber == pageNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TrendingNewsAutoRefreshRef
    on AutoDisposeStreamNotifierProviderRef<List<Announcement>> {
  /// The parameter `pageNumber` of this provider.
  int get pageNumber;
}

class _TrendingNewsAutoRefreshProviderElement
    extends AutoDisposeStreamNotifierProviderElement<TrendingNewsAutoRefresh,
        List<Announcement>> with TrendingNewsAutoRefreshRef {
  _TrendingNewsAutoRefreshProviderElement(super.provider);

  @override
  int get pageNumber => (origin as TrendingNewsAutoRefreshProvider).pageNumber;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
