import 'dart:convert';
import 'package:first_flutter_app/data/constants.dart';
import 'package:first_flutter_app/data/models/cart_item.dart';
import 'package:http/http.dart' as http;

class OrderApi {
  static Future<void> placeOrder(List<CartItem> cartItems, String token) async {
    final url = Uri.parse('${KConstants.baseUrl}/orders');

    final productIds = cartItems.map((item) => item.product.id).toList();

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'product_ids': productIds}),
    );

    if (response.statusCode == 200) {
      print('Order successful!');
    } else {
      print('Failed to place order: ${response.body}');
    }
  }
}
