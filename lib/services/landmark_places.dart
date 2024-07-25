import 'dart:convert';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/models/land-marks-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LandmarkProvider extends ChangeNotifier {
  
  List<LandmarkModel> _key = [];

  List<LandmarkModel> get key => _key;
  
  Future<List<LandmarkModel>> fetchLandmarkPlace(int trend_id) async {
    String token = await getToken();
    final response = await http
        .get(Uri.parse(landmarkPlaces + '/${trend_id}'), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> data = jsonData['data'];
      _key = data.map((e) => LandmarkModel.fromJson(e)).toList();
      notifyListeners();
      return _key;
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

}
