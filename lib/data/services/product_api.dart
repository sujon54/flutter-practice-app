import 'dart:convert';
import 'package:first_flutter_app/data/constants.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductApi {
  static Future<List<Product>> fetchProducts({String? token}) async {
    final response = await http.get(
      Uri.parse('${KConstants.baseUrl}/products'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded['data'] ?? decoded['products'] ?? [];
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to fetch products: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<Product> fetchProductById(String id) async {
    final response = await http.get(
      Uri.parse('${KConstants.baseUrl}/products/$id'),
    );
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to load product: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<http.Response> addProduct({
    required String name,
    required String stock,
    required String price,
    required String description,
    required String imageUrl,
    required int categoryId,
    required String token,
  }) async {
    final url = Uri.parse('${KConstants.baseUrl}/products');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'stock': stock,
        'description': description,
        'image_url': imageUrl,
        'category_id': categoryId,
      }),
    );

    return response;
  }

  static Future<void> deleteProduct(String token, int id) async {
    final response = await http.delete(
      Uri.parse('${KConstants.baseUrl}/products/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
