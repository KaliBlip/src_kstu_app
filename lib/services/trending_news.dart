import 'dart:convert';
import 'package:src_kstu_app/models/announcement.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:connectivity/connectivity.dart';

class TrendingNewsProvider extends ChangeNotifier {
  List<Announcement> _trend = [];

  List<Announcement> get trend => _trend;

  Future<List<Announcement>> fetchTrend(int currentPageNumber) async {
    
    String token = await getToken();
    final response = await http.get(Uri.parse(trendingUrl+ '?page='+currentPageNumber.toString()), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData =
          json.decode(response.body)['announcements'];
      final List<dynamic> data = jsonData['data'];
      _trend = data.map((e) => Announcement.fromJson(e)).toList();

      notifyListeners();
      return _trend;
    } else if (response.statusCode == 401) {
      print('401 t');
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to fetch noticeboard!');
    }
  }
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  // Future<List<Announcement>> fetchTrend(context, int currentPageNumber) async {
    // final connection =
    //     Provider.of<ConnectivityProvider>(context, listen: false);
    // if (connection.status == ConnectivityStatus.Offline) {
    //   // throw Exception('No internet connection ');
    //   // Client is offline, retrieve the stored _trend from shared preferences
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   dynamic storedTrendStrings = await prefs.getStringList('trend');
    //   print(await prefs.getStringList('trend') ?? "sloww");

    //   if (storedTrendStrings != null) {
    //     print("not null oo");
    //     // List<Announcement> _trend = storedTrendStrings
    //     //     .map((string) => Announcement.fromJson(json.decode(string)))
    //     //     .toList();
    //     //     _trend =
    //     // storedTrendStrings.map((announcement) => announcement.fr).toList();
    //     _trend =
    //         storedTrendStrings.map((e) => Announcement.fromJson(e)).toList();

    //     notifyListeners();

    //     return _trend;
    //   } else {
    //     throw Exception('No internet connection and no stored trend');
    //   }
    // } else {
    //   // throw Exception('Yes internet ');
    //   // meaning client is connected either on wifi or cellular net
    //   String token = await getToken();
    //   final response = await http.get(
    //       Uri.parse(trendingUrl + '?page=' + currentPageNumber.toString()),
    //       headers: {
    //         "Accept": "application/json",
    //         'Authorization': 'Bearer $token'
    //       });

    //   if (response.statusCode == 200) {
    //     notifyListeners();

    //     Map<String, dynamic> jsonData =
    //         json.decode(response.body)['announcements'];
    //     final List<dynamic> data = jsonData['data'];
    //     _trend = data.map((e) => Announcement.fromJson(e)).toList();
    //     // print(_trend);

    //     // Store the _trend in shared preferences
    //     // Conversion of  List<Announcement> to List<String>
    //     List<String> trendStrings = _trend
    //         .map((announcement) => json.encode(announcement.toJson()))
    //         .toList();
    //     // print(trendStrings);
    //     // Store the _trend in shared preferences
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     await prefs.setStringList('trend', trendStrings);

        
    //     // 
    //     List<String>? trendStrings2 = await prefs.getStringList('trend');
    //     //  _trend.clear();

    //     _trend = trendStrings2!
    //         .map((string) => Announcement.fromJson(json.decode(string)))
    //         .toList();
    //     print(_trend.length);
    //     // 

    //     return _trend;

    //   } else if (response.statusCode == 401) {
    //     throw Exception('Unauthorized!');
    //   } else {
    //     throw Exception('Failed to fetch noticeboard!');
    //   }
    // }
  // }

  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token") ?? '';
  }

  Future<Announcement> fetchTrendDetails(int trend_id) async {
    String token = await getToken();
    final response = await http
        .get(Uri.parse(announcementDetailUrl + '/${trend_id}'), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      return Announcement.fromJson(jsonDecode(response.body)["data"]);
    } else if (response.statusCode == 401) {
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to fetch data from api!');
    }
  }
}
