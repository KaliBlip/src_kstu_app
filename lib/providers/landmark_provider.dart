import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:src_kstu_app/models/land-marks-model.dart';
import 'package:src_kstu_app/providers/auth_provider.dart';

part 'landmark_provider.g.dart';

@riverpod
class LandmarkNotifier extends _$LandmarkNotifier {
  @override
  List<LandmarkModel> build() {
    return [];
  }

  Future<List<LandmarkModel>> fetchLandmarkPlaces(int trendId) async {
    final token = await ref.read(authTokenProvider.future);
    final response = await http.get(
      Uri.parse('$landmarkPlaces/$trendId'),
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> data = jsonData['data'];
      final landmarks = data.map((e) => LandmarkModel.fromJson(e)).toList();
      
      state = landmarks;
      return landmarks;
    } else if (response.statusCode == 401) {
      throw Exception(jsonDecode(response.body)['message']);
    } else {
      throw Exception('Failed to fetch landmark places!');
    }
  }

  // Alias for compatibility
  Future<List<LandmarkModel>> fetchLandmarks(int trendId) => fetchLandmarkPlaces(trendId);
}

// Auto-refresh provider for real-time updates
@riverpod
class LandmarkAutoRefresh extends _$LandmarkAutoRefresh {
  @override
  Stream<List<LandmarkModel>> build(int trendId) async* {
    while (true) {
      try {
        final landmarks = await ref.read(landmarkNotifierProvider.notifier).fetchLandmarkPlaces(trendId);
        yield landmarks;
      } catch (e) {
        // Handle error silently for auto-refresh
      }
      
      // Refresh every 60 seconds (landmarks change less frequently)
      await Future.delayed(const Duration(seconds: 60));
    }
  }
}

// Provider for landmark places with caching
@riverpod
Future<List<LandmarkModel>> landmarkPlaces(LandmarkPlacesRef ref, int trendId) async {
  return await ref.read(landmarkNotifierProvider.notifier).fetchLandmarkPlaces(trendId);
}