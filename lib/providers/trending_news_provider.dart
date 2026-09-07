import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:src_kstu_app/models/announcement.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/providers/auth_provider.dart';
import 'package:src_kstu_app/utils/announcement_sort.dart';

part 'trending_news_provider.g.dart';

@riverpod
class TrendingNewsNotifier extends _$TrendingNewsNotifier {
  @override
  List<Announcement> build() {
    return [];
  }

  Future<List<Announcement>> fetchTrend(int currentPageNumber) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      // Always fetch the latest from the API so newly posted announcements
      // show up right away.
      final token = await ref.read(authTokenProvider.future);
      final response = await http.get(
        Uri.parse(trendingUrl + '?page=' + currentPageNumber.toString()),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
            json.decode(response.body)['announcements'];
        final List<dynamic> data = jsonData['data'];
        final trends = sortAnnouncementsByNewest(
            data.map((e) => Announcement.fromJson(e)).toList());

        // Cache the latest data purely as an offline fallback.
        await prefs.setString(
            'cached_trend_page_$currentPageNumber', json.encode(data));

        state = trends;
        return trends;
      } else if (response.statusCode == 401) {
        throw Exception(jsonDecode(response.body)['message']);
      } else {
        throw Exception('Failed to fetch trending news!');
      }
    } catch (e) {
      // Request failed (e.g. offline): fall back to the last cached page.
      final cachedTrends =
          prefs.getString('cached_trend_page_$currentPageNumber');
      if (cachedTrends != null) {
        final List<dynamic> cachedData = json.decode(cachedTrends);
        final trends = sortAnnouncementsByNewest(
            cachedData.map((e) => Announcement.fromJson(e)).toList());
        state = trends;
        return trends;
      }
      rethrow;
    }
  }

  Future<Announcement> fetchTrendDetails(int trendId) async {
    final token = await ref.read(authTokenProvider.future);
    final response = await http.get(
      Uri.parse(announcementDetailUrl + '/$trendId'),
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
    );
    
    if (response.statusCode == 200) {
      return Announcement.fromJson(jsonDecode(response.body)["data"]);
    } else if (response.statusCode == 401) {
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to fetch data from api!');
    }
  }

  void clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith('cached_trend_page_'));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}

// Auto-refresh provider for real-time updates
@riverpod
class TrendingNewsAutoRefresh extends _$TrendingNewsAutoRefresh {
  @override
  Stream<List<Announcement>> build(int pageNumber) async* {
    while (true) {
      try {
        final trends = await ref.read(trendingNewsNotifierProvider.notifier).fetchTrend(pageNumber);
        yield trends;
      } catch (e) {
        // Handle error silently for auto-refresh
      }
      
      // Refresh every 30 seconds
      await Future.delayed(const Duration(seconds: 30));
    }
  }
}

// Provider for trending news details with auto-refresh
@riverpod
Future<Announcement> trendingNewsDetails(TrendingNewsDetailsRef ref, int trendId) async {
  return await ref.read(trendingNewsNotifierProvider.notifier).fetchTrendDetails(trendId);
}