import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:src_kstu_app/models/announcement.dart';
import 'package:src_kstu_app/providers/auth_provider.dart';

part 'announcement_pagination_provider.g.dart';

class PaginationState {
  final List<Announcement> items;
  final int currentPage;
  final int totalPages;
  final bool isLoading;

  const PaginationState({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.isLoading,
  });

  PaginationState copyWith({
    List<Announcement>? items,
    int? currentPage,
    int? totalPages,
    bool? isLoading,
  }) {
    return PaginationState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class AnnouncementPaginationNotifier extends _$AnnouncementPaginationNotifier {
  @override
  PaginationState build() {
    return const PaginationState(
      items: [],
      currentPage: 1,
      totalPages: 1,
      isLoading: false,
    );
  }

  Future<List<Announcement>> fetchItems() async {
    state = state.copyWith(isLoading: true);

    try {
      final token = await ref.read(authTokenProvider.future);
      
      // Simulate delay for better UX
      await Future.delayed(const Duration(seconds: 2));

      final url = "https://ask-kstu-backend-v2-kingthrive-com.stackstaging.com/api/v1/announcements/trending-news?page=${state.currentPage}";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body)['announcements'];
        final List<dynamic> data = jsonData['data'];
        final items = data.map((e) => Announcement.fromJson(e)).toList();

        state = state.copyWith(
          items: items,
          currentPage: jsonData['current_page'],
          totalPages: jsonData['last_page'],
          isLoading: false,
        );

        return items;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized!');
      } else {
        throw Exception('Failed to fetch announcements!');
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      throw Exception(error);
    }
  }

  void nextPage() {
    if (state.currentPage < state.totalPages) {
      state = state.copyWith(currentPage: state.currentPage + 1);
      fetchItems();
    } else if (state.currentPage == state.totalPages) {
      state = state.copyWith(currentPage: 1);
      fetchItems();
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      state = state.copyWith(currentPage: page);
      fetchItems();
    }
  }
}

// Auto-refresh provider for real-time updates
@riverpod
class AnnouncementPaginationAutoRefresh extends _$AnnouncementPaginationAutoRefresh {
  @override
  Stream<PaginationState> build() async* {
    while (true) {
      try {
        await ref.read(announcementPaginationNotifierProvider.notifier).fetchItems();
        yield ref.read(announcementPaginationNotifierProvider);
      } catch (e) {
        // Handle error silently for auto-refresh
      }
      
      // Refresh every 30 seconds
      await Future.delayed(const Duration(seconds: 30));
    }
  }
}