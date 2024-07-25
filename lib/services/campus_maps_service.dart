import 'dart:convert';
import 'package:src_kstu_app/models/campus_map_model.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CampusMapProvider extends ChangeNotifier {
  List<CampusMapModel> _map = [];

  List<CampusMapModel> get map => _map;

  Future<List<CampusMapModel>> fetchNotice(String url) async {
    String token = await getToken();
    final response = await http.get(Uri.parse(url), headers: {

      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData =
          json.decode(response.body)['campus_landmarks'];
      final List<dynamic> data = jsonData['data'];
      _map = data.map((e) => CampusMapModel.fromJson(e)).toList();
      notifyListeners();
      return _map;
    } else if (response.statusCode == 401) {
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to fetch noticeboard!');
    }
  }
  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token") ?? '';
  }

    Future<CampusMapModel> fetchMapDetails(int trend_id) async {
    String token = await getToken();
    final response = await http
        .get(Uri.parse(camMapDetailUrl + '/${trend_id}'), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      return CampusMapModel.fromJson(jsonDecode(response.body)["data"]);
    } else if (response.statusCode == 401) {
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to fetch data from api!');
    }
  }
}
