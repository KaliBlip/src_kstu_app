// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_board_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noticeBoardNotifierHash() =>
    r'a4b6be92bc1f48cf9ab945a4bd3411990333ae92';

/// See also [NoticeBoardNotifier].
@ProviderFor(NoticeBoardNotifier)
final noticeBoardNotifierProvider = AutoDisposeNotifierProvider<
    NoticeBoardNotifier, List<Announcement>>.internal(
  NoticeBoardNotifier.new,
  name: r'noticeBoardNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$noticeBoardNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NoticeBoardNotifier = AutoDisposeNotifier<List<Announcement>>;
String _$noticeBoardAutoRefreshHash() =>
    r'6dcbff1675a71ebdb2ca206ae85f399ba80b599b';

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

abstract class _$NoticeBoardAutoRefresh
    extends BuildlessAutoDisposeStreamNotifier<List<Announcement>> {
  late final int pageNumber;

  Stream<List<Announcement>> build(
    int pageNumber,
  );
}

/// See also [NoticeBoardAutoRefresh].
@ProviderFor(NoticeBoardAutoRefresh)
const noticeBoardAutoRefreshProvider = NoticeBoardAutoRefreshFamily();

/// See also [NoticeBoardAutoRefresh].
class NoticeBoardAutoRefreshFamily
    extends Family<AsyncValue<List<Announcement>>> {
  /// See also [NoticeBoardAutoRefresh].
  const NoticeBoardAutoRefreshFamily();

  /// See also [NoticeBoardAutoRefresh].
  NoticeBoardAutoRefreshProvider call(
    int pageNumber,
  ) {
    return NoticeBoardAutoRefreshProvider(
      pageNumber,
    );
  }

  @override
  NoticeBoardAutoRefreshProvider getProviderOverride(
    covariant NoticeBoardAutoRefreshProvider provider,
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
  String? get name => r'noticeBoardAutoRefreshProvider';
}

/// See also [NoticeBoardAutoRefresh].
class NoticeBoardAutoRefreshProvider
    extends AutoDisposeStreamNotifierProviderImpl<NoticeBoardAutoRefresh,
        List<Announcement>> {
  /// See also [NoticeBoardAutoRefresh].
  NoticeBoardAutoRefreshProvider(
    int pageNumber,
  ) : this._internal(
          () => NoticeBoardAutoRefresh()..pageNumber = pageNumber,
          from: noticeBoardAutoRefreshProvider,
          name: r'noticeBoardAutoRefreshProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noticeBoardAutoRefreshHash,
          dependencies: NoticeBoardAutoRefreshFamily._dependencies,
          allTransitiveDependencies:
              NoticeBoardAutoRefreshFamily._allTransitiveDependencies,
          pageNumber: pageNumber,
        );

  NoticeBoardAutoRefreshProvider._internal(
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
    covariant NoticeBoardAutoRefresh notifier,
  ) {
    return notifier.build(
      pageNumber,
    );
  }

  @override
  Override overrideWith(NoticeBoardAutoRefresh Function() create) {
    return ProviderOverride(
      origin: this,
      override: NoticeBoardAutoRefreshProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<NoticeBoardAutoRefresh,
      List<Announcement>> createElement() {
    return _NoticeBoardAutoRefreshProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoticeBoardAutoRefreshProvider &&
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
mixin NoticeBoardAutoRefreshRef
    on AutoDisposeStreamNotifierProviderRef<List<Announcement>> {
  /// The parameter `pageNumber` of this provider.
  int get pageNumber;
}

class _NoticeBoardAutoRefreshProviderElement
    extends AutoDisposeStreamNotifierProviderElement<NoticeBoardAutoRefresh,
        List<Announcement>> with NoticeBoardAutoRefreshRef {
  _NoticeBoardAutoRefreshProviderElement(super.provider);

  @override
  int get pageNumber => (origin as NoticeBoardAutoRefreshProvider).pageNumber;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
