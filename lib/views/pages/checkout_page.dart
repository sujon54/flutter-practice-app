import 'package:first_flutter_app/data/providers/cart_notifier.dart';
import 'package:first_flutter_app/data/providers/auth_provider.dart';
import 'package:first_flutter_app/data/services/order_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckoutPage extends ConsumerWidget {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  CheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Shipping Address'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final cartItems = ref.read(cartProvider);
                final token = ref.read(authTokenProvider);

                final address = addressController.text.trim();
                final phone = phoneController.text.trim();

                if (cartItems.isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Cart is empty")));
                  return;
                }

                if (address.isEmpty || phone.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please enter name and phone number"),
                    ),
                  );
                  return;
                }

                await OrderApi.placeOrder(cartItems, token!);

                ref.read(cartProvider.notifier).clearCart();
                
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Order placed!")));
              },
              child: Text("Place Order"),
            ),
          ],
        ),
      ),
    );
  }
}
