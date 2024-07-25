import 'dart:convert';

import 'package:src_kstu_app/models/announcement.dart';
import 'package:src_kstu_app/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AnnouncementPaginationProvider with ChangeNotifier {
  List<Announcement> _trend = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;

  List<Announcement> get trend => _trend;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;

  Future<List<Announcement>> fetchItems() async {
    String token = await getToken();
    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(Duration(seconds: 2));

      String url =
          "https://ask-kstu-backend-v2-kingthrive-com.stackstaging.com/api/v1/announcements/trending-news?page=" +
              _currentPage.toString();

      final response = await http.get(Uri.parse(url), headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData =
            json.decode(response.body)['announcements'];
        final List<dynamic> data = jsonData['data'];
        _trend = data.map((e) => Announcement.fromJson(e)).toList();

        _currentPage = jsonData['current_page'];
        _totalPages = jsonData['last_page'];
        _isLoading = false;

        notifyListeners();
        return _trend;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized!');
      } else {
        throw Exception('Failed to fetch noticeboard!');
      }
    } catch (error) {
      throw Exception(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextPage() {
    if (_currentPage < _totalPages) {
      _currentPage++;
      fetchItems();
    } else if (_currentPage == _totalPages) {
      _currentPage = 1;
      fetchItems();
    }
  }
}