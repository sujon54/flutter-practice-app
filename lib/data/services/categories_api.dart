import 'dart:convert';
import 'package:first_flutter_app/data/constants.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoriesApi {
  static Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('${KConstants.baseUrl}/categories'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded['data'] ?? decoded['categories'] ?? [];
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<http.Response> addCategory(String name, String token) async {
    final response = await http.post(
      Uri.parse('${KConstants.baseUrl}/categories'),
      body: jsonEncode({'name': name}),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add category: ${response.body}');
    }
    return response;
  }
}
