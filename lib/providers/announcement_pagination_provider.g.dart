// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_pagination_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$announcementPaginationNotifierHash() =>
    r'84f9a093fcfe378f28062a50de3922c18e114e7d';

/// See also [AnnouncementPaginationNotifier].
@ProviderFor(AnnouncementPaginationNotifier)
final announcementPaginationNotifierProvider = AutoDisposeNotifierProvider<
    AnnouncementPaginationNotifier, PaginationState>.internal(
  AnnouncementPaginationNotifier.new,
  name: r'announcementPaginationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$announcementPaginationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AnnouncementPaginationNotifier = AutoDisposeNotifier<PaginationState>;
String _$announcementPaginationAutoRefreshHash() =>
    r'66519d84281349cfda38025b71b2a8950e9d2f12';

/// See also [AnnouncementPaginationAutoRefresh].
@ProviderFor(AnnouncementPaginationAutoRefresh)
final announcementPaginationAutoRefreshProvider =
    AutoDisposeStreamNotifierProvider<AnnouncementPaginationAutoRefresh,
        PaginationState>.internal(
  AnnouncementPaginationAutoRefresh.new,
  name: r'announcementPaginationAutoRefreshProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$announcementPaginationAutoRefreshHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AnnouncementPaginationAutoRefresh
    = AutoDisposeStreamNotifier<PaginationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
