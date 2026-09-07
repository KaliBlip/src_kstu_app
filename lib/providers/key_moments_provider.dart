import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:src_kstu_app/models/annoucement_key_moment.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/providers/auth_provider.dart';

part 'key_moments_provider.g.dart';

@riverpod
class KeyMomentsNotifier extends _$KeyMomentsNotifier {
  @override
  List<AnnouncementKeyMoments> build() {
    return [];
  }

  Future<List<AnnouncementKeyMoments>> fetchKeyMoments(int trendId) async {
    final token = await ref.read(authTokenProvider.future);
    final response = await http.get(
      Uri.parse(keyMomentsUrl + '/$trendId'),
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> data = jsonData['data'];
      final keyMoments = data.map((e) => AnnouncementKeyMoments.fromJson(e)).toList();
      
      state = keyMoments;
      return keyMoments;
    } else if (response.statusCode == 401) {
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to fetch key moments!');
    }
  }
}

// Auto-refresh provider for real-time updates
@riverpod
class KeyMomentsAutoRefresh extends _$KeyMomentsAutoRefresh {
  @override
  Stream<List<AnnouncementKeyMoments>> build(int trendId) async* {
    while (true) {
      try {
        final keyMoments = await ref.read(keyMomentsNotifierProvider.notifier).fetchKeyMoments(trendId);
        yield keyMoments;
      } catch (e) {
        // Handle error silently for auto-refresh
      }
      
      // Refresh every 15 seconds (key moments are more dynamic)
      await Future.delayed(const Duration(seconds: 15));
    }
  }
}

// Provider for key moments with caching
@riverpod
Future<List<AnnouncementKeyMoments>> keyMoments(KeyMomentsRef ref, int trendId) async {
  return await ref.read(keyMomentsNotifierProvider.notifier).fetchKeyMoments(trendId);
}