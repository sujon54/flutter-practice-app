import 'package:first_flutter_app/data/providers/auth_provider.dart';
import 'package:first_flutter_app/data/providers/products_provider.dart';
import 'package:first_flutter_app/views/pages/add_product_page.dart';
import 'package:first_flutter_app/views/widget/product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    final productAsyncValue = ref.watch(productProvider);
    final user = ref.watch(localUserProvider);

    return Scaffold(
      body: productAsyncValue.when(
        data: (products) {
          if (products.isEmpty) {
            return Center(child: Text('No products available'));
          }
          return GridView.builder(
            padding: EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItem(product: product);
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => ref.refresh(productProvider),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: user?.role == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddProductPage(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
