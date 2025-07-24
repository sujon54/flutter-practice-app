import 'package:first_flutter_app/data/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authProvider = StateProvider<bool>((ref) {
  return false;
});

final authTokenProvider = StateProvider<String?>((ref) {
  return null;
});

final localUserProvider = StateProvider<User?>((ref) => null);

class AuthProvider {
  static const _storage = FlutterSecureStorage();

  static Future<void> initializeAuth(WidgetRef ref) async {
    final token = await _storage.read(key: 'auth_token');
    ref.read(authProvider.notifier).state = token != null;
    ref.read(authTokenProvider.notifier).state = token;

    final userData = await getUserData();
    if (userData != null) {
      ref.read(localUserProvider.notifier).state = User(
        id: userData['id'],
        name: userData['name']!,
        email: userData['email']!,
        role: userData['role']!,
      );
    }
  }

  static Future<void> saveToken(String token, WidgetRef ref) async {
    await _storage.write(key: 'auth_token', value: token);
    ref.read(authProvider.notifier).state = true;
    ref.read(authTokenProvider.notifier).state = token;
  }

  static Future<void> logout(WidgetRef ref) async {
    await _storage.delete(key: 'auth_token');
    await clearUserData();
    ref.read(authProvider.notifier).state = false;
    ref.read(authTokenProvider.notifier).state = null;
    ref.read(localUserProvider.notifier).state = null;
  }

  static Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', user.id);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_role', user.role ?? '');
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    final name = prefs.getString('user_name');
    final email = prefs.getString('user_email');
    final role = prefs.getString('user_role');

    if (id != null && name != null && email != null && role != null) {
      return {'id': id, 'name': name, 'email': email, 'role': role};
    }
    return null;
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_role');
  }
}
