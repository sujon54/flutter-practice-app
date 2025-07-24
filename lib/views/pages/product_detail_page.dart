import 'package:first_flutter_app/data/models/cart_item.dart';
import 'package:first_flutter_app/data/models/product.dart';
import 'package:first_flutter_app/data/providers/cart_notifier.dart';
import 'package:first_flutter_app/views/pages/cart_page.dart';
import 'package:first_flutter_app/views/widget/cart_icon_with_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailPage extends ConsumerWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void addToCart() {
      final item = CartItem(product: product, quantity: 1);
      ref.read(cartProvider.notifier).addToCart(item);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          CartIconWithBadge(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Image.network(product.imageUrl),
                SizedBox(height: 16),
                Text(
                  product.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${product.price}',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
                SizedBox(height: 16),
                Text(product.description),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: addToCart,
                  icon: Icon(Icons.shopping_cart),
                  label: Text('Add to Cart'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:first_flutter_app/data/models/product.dart';
// import 'package:flutter/material.dart';

// class ProductDetailPage extends StatelessWidget {
//   final Product product;

//   const ProductDetailPage({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(product.name)),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(product.imageUrl),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.name,
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     '\$${product.price}',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Text(product.description, style: TextStyle(fontSize: 14)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // import 'package:first_flutter_app/data/models/product.dart';
// // import 'package:first_flutter_app/data/services/product_api.dart';
// // import 'package:flutter/material.dart';

// // class ProductDetailsPage extends StatefulWidget {
// //   const ProductDetailsPage({super.key, required this.productId});
// //   final String productId;

// //   @override
// //   // ignore: library_private_types_in_public_api
// //   _ProductDetailsPageState createState() => _ProductDetailsPageState();
// // }

// // class _ProductDetailsPageState extends State<ProductDetailsPage> {
// //   Future<Product>? futureProduct;

// //   @override
// //   void initState() {
// //     ProductApi.fetchProductById(widget.productId)
// //         .then((product) {
// //           setState(() {
// //             futureProduct = Future.value(product);
// //           });
// //         })
// //         .catchError((error) {
// //           setState(() {
// //             futureProduct = Future.error(error);
// //           });
// //         });
// //     super.initState();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         FutureBuilder<Product>(
// //           future: futureProduct,
// //           builder: (context, snapshot) {
// //             if (snapshot.connectionState == ConnectionState.waiting) {
// //               return const Center(child: CircularProgressIndicator());
// //             } else if (snapshot.hasError) {
// //               return Center(child: Text('Error: ${snapshot.error}'));
// //             } else if (!snapshot.hasData) {
// //               return const Center(child: Text('No product found'));
// //             }

// //             final product = snapshot.data!;
// //             return Padding(
// //               padding: const EdgeInsets.all(20.0),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     product.name,
// //                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //                   ),
// //                   SizedBox(height: 10),
// //                   Text(product.description, style: TextStyle(fontSize: 16)),
// //                   SizedBox(height: 10),
// //                   Text(
// //                     '\$${product.price}',
// //                     style: TextStyle(fontSize: 20, color: Colors.green),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //         ),
// //       ],
// //     );
// //   }
// // }
