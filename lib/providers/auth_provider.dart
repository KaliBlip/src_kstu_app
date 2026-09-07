import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_provider.g.dart';

@riverpod
Future<String> authToken(AuthTokenRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("token") ?? '';
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  String build() {
    _loadToken();
    return '';
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString("token") ?? '';
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    state = token;
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    state = '';
  }
}