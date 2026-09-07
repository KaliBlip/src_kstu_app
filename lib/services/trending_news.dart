import 'dart:convert';
import 'package:src_kstu_app/models/announcement.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/utils/announcement_sort.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class TrendingNewsProvider extends ChangeNotifier {
  List<Announcement> _trend = [];

  List<Announcement> get trend => _trend;

  Future<List<Announcement>> fetchTrend(int currentPageNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      // Always fetch the latest from the API so newly posted announcements
      // show up right away.
      String token = await getToken();
      final response = await http.get(
          Uri.parse(trendingUrl + '?page=' + currentPageNumber.toString()),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $token'
          });

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData =
            json.decode(response.body)['announcements'];
        final List<dynamic> data = jsonData['data'];
        _trend = sortAnnouncementsByNewest(
            data.map((e) => Announcement.fromJson(e)).toList());

        // Cache the latest data purely as an offline fallback.
        await prefs.setString(
            'cached_trend_page_$currentPageNumber', json.encode(data));

        notifyListeners();
        return _trend;
      } else if (response.statusCode == 401) {
        print('401 t');
        throw Exception(jsonDecode(response.body)['message']);
      } else {
        throw Exception('Failed to fetch noticeboard!');
      }
    } catch (e) {
      // Request failed (e.g. offline): fall back to the last cached page.
      final cachedTrends =
          prefs.getString('cached_trend_page_$currentPageNumber');
      if (cachedTrends != null) {
        final List<dynamic> cachedData = json.decode(cachedTrends);
        _trend = sortAnnouncementsByNewest(
            cachedData.map((e) => Announcement.fromJson(e)).toList());
        notifyListeners();
        return _trend;
      }
      rethrow;
    }
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

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
