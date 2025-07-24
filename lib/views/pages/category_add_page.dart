import 'package:first_flutter_app/data/providers/auth_provider.dart';
import 'package:first_flutter_app/data/providers/categories_provder.dart';
import 'package:first_flutter_app/data/services/categories_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CategoryAddPage extends ConsumerStatefulWidget {
  const CategoryAddPage({super.key});

  @override
  ConsumerState<CategoryAddPage> createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends ConsumerState<CategoryAddPage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a category name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = ref.read(authTokenProvider);
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to add a category')),
        );
        return;
      }
      http.Response response = await CategoriesApi.addCategory(name, token);

      if (response.statusCode == 200) {
        _nameController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category added')),
        );
      
        // ignore: unused_result
        ref.refresh(categoriesProvider);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Category')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _submit,
              icon: const Icon(Icons.save),
              label: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}
