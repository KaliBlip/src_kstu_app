import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

enum ConnectivityStatus { Wifi, Cellular, Offline }

class ConnectivityProvider with ChangeNotifier {
  ConnectivityStatus _status = ConnectivityStatus.Cellular;
  ConnectivityStatus get status => _status;

  ConnectivityProvider() {
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
    _status = ConnectivityStatus.Wifi;
    break;
  case ConnectivityResult.mobile:
    _status = ConnectivityStatus.Cellular;
    break;
 
  default:
    // _status = ConnectivityStatus.Offline;
    break;
    }
    notifyListeners();
  }
}
