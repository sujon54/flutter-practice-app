import 'package:first_flutter_app/data/providers/cart_notifier.dart';
import 'package:first_flutter_app/views/pages/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.watch(cartProvider.notifier).totalPrice;

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  // leading: Image.network(item.product.imageUrl, width: 50),
                  title: Text(item.product.name),
                  subtitle: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          ref
                              .read(cartProvider.notifier)
                              .decreaseQuantity(item.product);
                          // if (item.quantity > 1) {
                          //   final updatedItem = CartItem(
                          //     product: item.product,
                          //     quantity: item.quantity - 1,
                          //   );
                          //   final updatedList = [...cartItems];
                          //   updatedList[index] = updatedItem;
                          //   ref.read(cartProvider.notifier).state = updatedList;
                          // } else {
                          //   ref
                          //       .read(cartProvider.notifier)
                          //       .removeFromCart(item.product.id);
                          // }
                        },
                      ),
                      Text('${item.quantity}', style: TextStyle(fontSize: 16)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          ref
                              .read(cartProvider.notifier)
                              .increaseQuantity(item.product);
                          // final updatedItem = CartItem(
                          //   product: item.product,
                          //   quantity: item.quantity + 1,
                          // );
                          // final updatedList = [...cartItems];
                          // updatedList[index] = updatedItem;
                          // ref.read(cartProvider.notifier).state = updatedList;
                        },
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      ref
                          .read(cartProvider.notifier)
                          .removeFromCart(item.product.id);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text('Total:', style: TextStyle(fontSize: 16)),
                        Spacer(),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Add your order logic here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutPage(),
                            ),
                          );
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text('Order placed successfully!'),
                          //   ),
                          // );
                          // ref.read(cartProvider.notifier).clearCart();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text('Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
