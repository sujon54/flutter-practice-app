import 'package:first_flutter_app/data/models/product.dart';
import 'package:first_flutter_app/data/services/product_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider = FutureProvider<List<Product>>((ref) async {
  final token = ref.watch(authTokenProvider); // Optional token
  try {
    return await ProductApi.fetchProducts(token: token);
  } catch (e) {
    throw Exception('Failed to load products: $e');
  }
});

final authTokenProvider = Provider<String?>((ref) {
  return null; // Replace with your token logic
});

// import 'package:first_flutter_app/data/models/product.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import '../data/services/product_api.dart';

// // Provider for http.Client
// final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// // Provider for ProductApi
// final productApiProvider = Provider<ProductApi>((ref) {
//   final client = ref.watch(httpClientProvider);
//   return ProductApi(client: client);
// });

// // Products Notifier State
// class ProductsState {
//   final List<Product> products;
//   final bool isLoading;
//   final String? error;

//   ProductsState({
//     this.products = const [],
//     this.isLoading = false,
//     this.error,
//   });

//   ProductsState copyWith({
//     List<Product>? products,
//     bool? isLoading,
//     String? error,
//   }) {
//     return ProductsState(
//       products: products ?? this.products,
//       isLoading: isLoading ?? this.isLoading,
//       error: error ?? this.error,
//     );
//   }
// }

// // Products Notifier
// class ProductsNotifier extends StateNotifier<ProductsState> {
//   final ProductApi productApi;
//   final Ref ref;

//   ProductsNotifier(this.ref, {required this.productApi})
//       : super(ProductsState()) {
//     loadProducts();
//   }

//   Future<void> loadProducts() async {
//     state = state.copyWith(isLoading: true, error: null);
    
//     try {
//       final products = await productApi.fetchProducts();
//       state = state.copyWith(
//         products: products,
//         isLoading: false,
//       );
//     } on ApiException catch (e) {
//       state = state.copyWith(
//         error: e.message,
//         isLoading: false,
//       );
//     }
//   }

//   Future<void> deleteProduct(int id, String token) async {
//     state = state.copyWith(isLoading: true);
    
//     try {
//       await productApi.deleteProduct(id, token: token);
//       state = state.copyWith(
//         products: state.products.where((p) => p.id != id).toList(),
//         isLoading: false,
//       );
//     } on ApiException catch (e) {
//       state = state.copyWith(
//         error: e.message,
//         isLoading: false,
//       );
//       rethrow;
//     }
//   }

//   Future<void> refreshProducts() async {
//     await loadProducts();
//   }
// }

// // Products Provider
// final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
//   (ref) {
//     final productApi = ref.watch(productApiProvider);
//     return ProductsNotifier(ref, productApi: productApi);
//   },
// );
// import 'package:first_flutter_app/data/models/product.dart';
// import 'package:first_flutter_app/data/services/product_api.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // Provider for ApiService
// final apiServiceProvider = Provider<ProductApi>((ref) => ProductApi());

// // StateNotifier for products
// class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
//   final ProductApi apiService;

//   ProductsNotifier(this.apiService) : super(const AsyncValue.loading()) {
//     fetchProducts();
//   }

//   Future<void> fetchProducts() async {
//     state = const AsyncValue.loading();
//     try {
//       final products = await ProductApi.fetchProducts();
//       state = AsyncValue.data(products);
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }
// }

// // Products Notifier Provider
// final productsProvider = StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
//   final apiService = ref.watch(apiServiceProvider);
//   return ProductsNotifier(apiService);
// });