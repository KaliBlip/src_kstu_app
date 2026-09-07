import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

enum ConnectivityStatus { wifi, cellular, offline }

@riverpod
class ConnectivityNotifier extends _$ConnectivityNotifier {
  @override
  ConnectivityStatus build() {
    // Initialize with cellular as default
    _initConnectivity();
    return ConnectivityStatus.cellular;
  }

  void _initConnectivity() {
    // Listen to connectivity changes
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        _updateConnectionStatus(results.first);
      }
    });
    
    // Get initial connectivity status
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result.isNotEmpty) {
      _updateConnectionStatus(result.first);
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        state = ConnectivityStatus.wifi;
        break;
      case ConnectivityResult.mobile:
        state = ConnectivityStatus.cellular;
        break;
      case ConnectivityResult.none:
        state = ConnectivityStatus.offline;
        break;
      default:
        state = ConnectivityStatus.offline;
        break;
    }
  }
}

// Stream provider for real-time connectivity updates
@riverpod
Stream<ConnectivityStatus> connectivityStream(ConnectivityStreamRef ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    if (results.isEmpty) return ConnectivityStatus.offline;
    
    switch (results.first) {
      case ConnectivityResult.wifi:
        return ConnectivityStatus.wifi;
      case ConnectivityResult.mobile:
        return ConnectivityStatus.cellular;
      case ConnectivityResult.none:
        return ConnectivityStatus.offline;
      default:
        return ConnectivityStatus.offline;
    }
  });
}