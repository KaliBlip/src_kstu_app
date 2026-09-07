# Flutter Provider to Riverpod Migration Guide

## Overview
This document outlines the complete migration from Provider to Riverpod state management with real-time updates for the KSTU app.

## Migration Summary

### 1. Dependencies Updated
- **Removed**: `provider: ^6.0.5`
- **Added**: 
  - `flutter_riverpod: ^2.4.9`
  - `riverpod_annotation: ^2.3.3`
  - `riverpod_generator: ^2.6.5` (dev dependency)
  - `build_runner: ^2.4.7` (dev dependency)
  - `json_annotation: ^4.8.1` (dev dependency)

### 2. New Riverpod Providers Created

#### Core Providers
- **`lib/providers/auth_provider.dart`** - Token management with automatic persistence
- **`lib/providers/connectivity_provider.dart`** - Real-time connectivity monitoring with streams

#### Data Providers with Real-time Updates
- **`lib/providers/notice_board_provider.dart`** - Notice board with auto-refresh every 30 seconds
- **`lib/providers/trending_news_provider.dart`** - Trending news with auto-refresh every 30 seconds
- **`lib/providers/campus_map_provider.dart`** - Campus maps with auto-refresh every 60 seconds
- **`lib/providers/key_moments_provider.dart`** - Key moments with auto-refresh every 15 seconds
- **`lib/providers/landmark_provider.dart`** - Landmarks with auto-refresh every 60 seconds
- **`lib/providers/announcement_pagination_provider.dart`** - Pagination with auto-refresh every 30 seconds

### 3. Real-time Features Added

#### Connectivity Monitoring
```dart
// Stream-based connectivity with real-time updates
@riverpod
Stream<ConnectivityStatus> connectivityStream(ConnectivityStreamRef ref) {
  return Connectivity().onConnectivityChanged.map((results) => {
    // Real-time connectivity status updates
  });
}
```

#### Auto-refresh Data Providers
Each data provider now includes auto-refresh capabilities:
- **Notice Board**: Refreshes every 30 seconds
- **Trending News**: Refreshes every 30 seconds  
- **Key Moments**: Refreshes every 15 seconds (more dynamic)
- **Campus Maps**: Refreshes every 60 seconds (less frequent changes)
- **Landmarks**: Refreshes every 60 seconds

### 4. Migration Benefits

#### Performance Improvements
- **Automatic Caching**: Riverpod provides built-in caching mechanisms
- **Selective Rebuilds**: Only widgets that depend on changed data rebuild
- **Memory Efficiency**: Providers are automatically disposed when not needed

#### Real-time Updates
- **Stream-based Connectivity**: Real-time network status monitoring
- **Auto-refresh Data**: Background data updates without user interaction
- **Optimistic Updates**: UI updates immediately while data syncs in background

#### Developer Experience
- **Type Safety**: Compile-time error checking with code generation
- **Dependency Injection**: Automatic dependency management
- **Testing**: Easier to mock and test providers

### 5. Code Generation
Run the following commands after making changes:
```bash
flutter packages get
dart run build_runner build
```

### 6. Usage Examples

#### Before (Provider)
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoticeBoardProvider>(context, listen: false);
    
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, _) {
        if (connectivity.status == ConnectivityStatus.Offline) {
          return OfflineWidget();
        }
        return OnlineWidget();
      },
    );
  }
}
```

#### After (Riverpod)
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityStreamProvider);
    
    return connectivityStatus.when(
      data: (status) {
        if (status == ConnectivityStatus.offline) {
          return OfflineWidget();
        }
        
        // Auto-refreshing data with real-time updates
        final noticesStream = ref.watch(noticeBoardAutoRefreshProvider(1));
        return noticesStream.when(
          data: (notices) => NoticesList(notices: notices),
          loading: () => LoadingWidget(),
          error: (error, stack) => ErrorWidget(),
        );
      },
      loading: () => LoadingWidget(),
      error: (error, stack) => ErrorWidget(),
    );
  }
}
```

### 7. Files Updated

#### Main Entry Point
- **`lib/main.dart`**: Replaced `MultiProvider` with `ProviderScope`

#### UI Pages (Partial Updates)
- **`lib/feature/pages/loading.dart`**: Updated to use Riverpod Consumer
- **`lib/feature/pages/dashboard.dart`**: Updated imports and Consumer usage

#### Remaining Files to Update
The following files still need Consumer and Provider.of updates:
- `lib/feature/pages/news_details.dart`
- `lib/feature/pages/about_page.dart`
- `lib/feature/pages/trending_news.dart`
- `lib/feature/pages/key_moments_container.dart`
- `lib/feature/pages/campus_map.dart`
- `lib/feature/pages/notice_board.dart`
- `lib/feature/landmark_container.dart`
- `lib/components/trending_component.dart`
- `lib/feature/pages/welcome_screen.dart`
- `lib/feature/pages/login_page.dart`

### 8. Migration Pattern

For each remaining file, follow this pattern:

1. **Update Imports**:
   ```dart
   // Remove
   import 'package:provider/provider.dart';
   import 'package:src_kstu_app/services/connectivity_provider.dart';
   
   // Add
   import 'package:flutter_riverpod/flutter_riverpod.dart';
   import 'package:src_kstu_app/providers/connectivity_provider.dart';
   ```

2. **Update Widget Classes**:
   ```dart
   // Change StatefulWidget to ConsumerStatefulWidget
   class MyPage extends ConsumerStatefulWidget {
     @override
     ConsumerState<MyPage> createState() => _MyPageState();
   }
   
   class _MyPageState extends ConsumerState<MyPage> {
     // Use ref instead of Provider.of
   }
   ```

3. **Update Provider Access**:
   ```dart
   // Before
   final provider = Provider.of<SomeProvider>(context, listen: false);
   
   // After
   final data = await ref.read(someProviderProvider.notifier).fetchData();
   ```

4. **Update Consumer Widgets**:
   ```dart
   // Before
   Consumer<ConnectivityProvider>(builder: (context, provider, _) {
     if (provider.status == ConnectivityStatus.Offline) {
       return OfflineWidget();
     }
     return OnlineWidget();
   })
   
   // After
   Consumer(builder: (context, ref, _) {
     final status = ref.watch(connectivityStreamProvider);
     return status.when(
       data: (connectivity) => connectivity == ConnectivityStatus.offline 
         ? OfflineWidget() 
         : OnlineWidget(),
       loading: () => LoadingWidget(),
       error: (error, stack) => ErrorWidget(),
     );
   })
   ```

### 9. Real-time Update Configuration

Each provider includes configurable refresh intervals:
- Modify the `Duration` in auto-refresh providers to adjust update frequency
- Use `ref.invalidate()` to manually trigger updates
- Stream providers automatically handle real-time updates

### 10. Testing
- All providers are easily testable with `ProviderContainer`
- Mock providers can be created for unit tests
- Integration tests can override providers with test data

## Next Steps
1. Complete the migration of remaining UI files
2. Test all functionality with real-time updates
3. Optimize refresh intervals based on usage patterns
4. Add error handling and retry logic for failed updates