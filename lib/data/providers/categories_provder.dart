import 'package:first_flutter_app/data/models/category.dart';
import 'package:first_flutter_app/data/services/categories_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return await CategoriesApi.fetchCategories();
});
