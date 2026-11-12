import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:src_kstu_app/models/campus_map_model.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/providers/auth_provider.dart';

part 'campus_map_provider.g.dart';

@riverpod
class CampusMapNotifier extends _$CampusMapNotifier {
  @override
  List<CampusMapModel> build() {
    return [];
  }

  Future<List<CampusMapModel>> fetchMaps(String url) async {
    final prefs = await SharedPreferences.getInstance();
    // Use url-based cache key so each campus has its own cache
    final cacheKey = 'cached_map_${url.hashCode}';
    final cachedMaps = prefs.getString(cacheKey);

    if (cachedMaps != null) {
      final List<dynamic> cachedData = json.decode(cachedMaps);
      final maps = cachedData.map((e) => CampusMapModel.fromJson(e)).toList();
      state = maps;
      return maps;
    }

    final token = await ref.read(authTokenProvider.future);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body)['campus_landmarks'];
      final List<dynamic> data = jsonData['data'];
      final maps = data.map((e) => CampusMapModel.fromJson(e)).toList();

      await prefs.setString(cacheKey, json.encode(data));

      state = maps;
      return maps;
    } else if (response.statusCode == 401) {
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to fetch campus maps!');
    }
  }

  // Alias for compatibility with legacy code
  Future<List<CampusMapModel>> fetchNotice(String url) => fetchMaps(url);

  Future<CampusMapModel> fetchMapDetails(int mapId) async {
    final token = await ref.read(authTokenProvider.future);
    final response = await http.get(
      Uri.parse(camMapDetailUrl + '/$mapId'),
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
    );
    
    if (response.statusCode == 200) {
      return CampusMapModel.fromJson(jsonDecode(response.body)["data"]);
    } else if (response.statusCode == 401) {
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to fetch data from api!');
    }
  }

  void clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_map_page');
  }
}

// Auto-refresh provider for real-time updates
@riverpod
class CampusMapAutoRefresh extends _$CampusMapAutoRefresh {
  @override
  Stream<List<CampusMapModel>> build(String url) async* {
    while (true) {
      try {
        final maps = await ref.read(campusMapNotifierProvider.notifier).fetchMaps(url);
        yield maps;
      } catch (e) {
        // Handle error silently for auto-refresh
      }
      
      // Refresh every 60 seconds (maps change less frequently)
      await Future.delayed(const Duration(seconds: 60));
    }
  }
}

// Provider for campus map details
@riverpod
Future<CampusMapModel> campusMapDetails(CampusMapDetailsRef ref, int mapId) async {
  return await ref.read(campusMapNotifierProvider.notifier).fetchMapDetails(mapId);
}