import 'dart:convert';
import 'package:src_kstu_app/models/announcement.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/utils/announcement_sort.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NoticeBoardProvider extends ChangeNotifier {
  List<Announcement> _notice = [];

  List<Announcement> get notice => _notice;

  Future<List<Announcement>> fetchNotice(int currentPageNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      // Always fetch the latest from the API so newly posted announcements
      // show up right away.
      String token = await getToken();
      final response = await http.get(
        Uri.parse('$noticeUrl?page=$currentPageNumber'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData =
            json.decode(response.body)['announcements'];
        final List<dynamic> data = jsonData['data'];
        _notice = sortAnnouncementsByNewest(
            data.map((e) => Announcement.fromJson(e)).toList());

        // Cache the latest data purely as an offline fallback.
        await prefs.setString(
            'cached_notices_page_$currentPageNumber', json.encode(data));

        notifyListeners();
        return _notice;
      } else if (response.statusCode == 401) {
        throw Exception(jsonDecode(response.body)['message']);
      } else {
        throw Exception('Failed to fetch noticeboard!');
      }
    } catch (e) {
      // Request failed (e.g. offline): fall back to the last cached page.
      final cachedNotices =
          prefs.getString('cached_notices_page_$currentPageNumber');
      if (cachedNotices != null) {
        final List<dynamic> cachedData = json.decode(cachedNotices);
        _notice = sortAnnouncementsByNewest(
            cachedData.map((e) => Announcement.fromJson(e)).toList());
        notifyListeners();
        return _notice;
      }
      rethrow;
    }
  }

  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token") ?? '';
  }
}
