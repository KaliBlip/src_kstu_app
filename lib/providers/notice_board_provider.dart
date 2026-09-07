import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:src_kstu_app/models/announcement.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/providers/auth_provider.dart';
import 'package:src_kstu_app/utils/announcement_sort.dart';

part 'notice_board_provider.g.dart';

@riverpod
class NoticeBoardNotifier extends _$NoticeBoardNotifier {
  @override
  List<Announcement> build() {
    return [];
  }

  Future<List<Announcement>> fetchNotice(int currentPageNumber) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      // Always fetch the latest from the API so newly posted announcements
      // show up right away.
      final token = await ref.read(authTokenProvider.future);
      final response = await http.get(
        Uri.parse('$noticeUrl?page=$currentPageNumber'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
            json.decode(response.body)['announcements'];
        final List<dynamic> data = jsonData['data'];
        final notices = sortAnnouncementsByNewest(
            data.map((e) => Announcement.fromJson(e)).toList());

        // Cache the latest data purely as an offline fallback.
        await prefs.setString(
            'cached_notices_page_$currentPageNumber', json.encode(data));

        state = notices;
        return notices;
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
        final notices = sortAnnouncementsByNewest(
            cachedData.map((e) => Announcement.fromJson(e)).toList());
        state = notices;
        return notices;
      }
      rethrow;
    }
  }

  void clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith('cached_notices_page_'));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}

// Auto-refresh provider for real-time updates
@riverpod
class NoticeBoardAutoRefresh extends _$NoticeBoardAutoRefresh {
  @override
  Stream<List<Announcement>> build(int pageNumber) async* {
    while (true) {
      try {
        final notices = await ref.read(noticeBoardNotifierProvider.notifier).fetchNotice(pageNumber);
        yield notices;
      } catch (e) {
        // Handle error silently for auto-refresh
      }
      
      // Refresh every 30 seconds
      await Future.delayed(const Duration(seconds: 30));
    }
  }
}