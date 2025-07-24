import 'dart:convert';
import 'package:first_flutter_app/data/constants.dart';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';

class AuthApi {
  static Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('${KConstants.baseUrl}/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid email or password');
      } else if (response.statusCode == 422) {
        final errors = jsonDecode(response.body)['errors'];
        throw Exception('Validation failed: $errors');
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<AuthResponse> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('${KConstants.baseUrl}/register'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'password_confirmation': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 422) {
        final errors = jsonDecode(response.body)['errors'];
        throw Exception('Validation failed: $errors');
      } else if (response.statusCode == 400) {
        throw Exception('Bad request: ${response.body}');
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
