import 'dart:convert';
import 'package:src_kstu_app/models/announcement.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NoticeBoardProvider extends ChangeNotifier {
  List<Announcement> _notice = [];

  List<Announcement> get notice => _notice;

  Future<List<Announcement>> fetchNotice(int currentPageNumber) async {

    String token = await getToken();
    print("hmm "+noticeUrl+ '?page='+currentPageNumber.toString());
    final response = await http.get(Uri.parse(noticeUrl+ '?page='+currentPageNumber.toString()), headers: {

      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData =
          json.decode(response.body)['announcements'];
      final List<dynamic> data = jsonData['data'];
      _notice = data.map((e) => Announcement.fromJson(e)).toList();
     print('notice here');
      print(_notice);
      notifyListeners();
      return _notice;
    } else if (response.statusCode == 401) {
      print('401 n');

      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to fetch noticeboard!');
    }
  }

  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token") ?? '';
  }
}
