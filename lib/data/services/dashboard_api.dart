import 'dart:convert';
import 'package:first_flutter_app/data/constants.dart';
import 'package:first_flutter_app/data/models/user.dart';
import 'package:http/http.dart' as http;

class DashboardApi {
  static Future<Map<String, dynamic>> fetchDashboard(String token) async {
    final response = await http.get(
      Uri.parse('${KConstants.baseUrl}/admin/stats'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load dashboard');
    }
  }

  static Future<List<User>> fetchUsers(String token) async {
    final response = await http.get(
      Uri.parse('${KConstants.baseUrl}/users'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded['data'] ?? decoded['users'] ?? [];
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<http.Response> deleteUser(String token, int id) async {
    final response = await http.delete(
      Uri.parse('${KConstants.baseUrl}/users/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return response;
  }
}
