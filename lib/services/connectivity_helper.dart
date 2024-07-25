import 'package:connectivity/connectivity.dart';

class ConnectivityHelper {
  Future<ConnectivityResult> checkConnectivity() async {
    return await Connectivity().checkConnectivity();
  }
}