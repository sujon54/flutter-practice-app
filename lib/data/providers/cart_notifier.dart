import 'package:first_flutter_app/data/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart_item.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]) {
    _loadCart();
  }

  void addToCart(CartItem item) {
    final index = state.indexWhere((i) => i.product.id == item.product.id);

    if (index == -1) {
      state = [...state, item];
    } else {
      final updated = [...state];
      updated[index].quantity += item.quantity;
      state = updated;
    }

    _saveCart();
  }

  void removeFromCart(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
    _saveCart();
  }

  void clearCart() {
    state = [];
    _saveCart();
  }

  double get totalPrice =>
      state.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(state.map((e) => e.toJson()).toList());
    prefs.setString('cart_items', jsonData);
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cart_items');
    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      state = decoded.map((e) => CartItem.fromJson(e)).toList();
    }
  }

  void increaseQuantity(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      final updatedItem = CartItem(
        product: product,
        quantity: state[index].quantity + 1,
      );
      final updatedList = [...state];
      updatedList[index] = updatedItem;
      state = updatedList;
      _saveCart();
    }
  }

  void decreaseQuantity(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1 && state[index].quantity > 1) {
      final updatedItem = CartItem(
        product: product,
        quantity: state[index].quantity - 1,
      );
      final updatedList = [...state];
      updatedList[index] = updatedItem;
      state = updatedList;
      _saveCart();
    }
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) => CartNotifier());
