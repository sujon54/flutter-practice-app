import 'dart:io';

import 'package:first_flutter_app/data/providers/auth_provider.dart';
import 'package:first_flutter_app/data/providers/categories_provder.dart';
import 'package:first_flutter_app/data/providers/products_provider.dart'
    hide authTokenProvider;
import 'package:first_flutter_app/data/services/product_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  String price = '';
  String stock = '';
  String imageUrl = '';
  int? selectedCategoryId;
  File? _imageFile;

  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: categoriesAsync.when(
          data: (categories) {
            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                    ),
                    onSaved: (value) => name = value!.trim(),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter product name' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    onSaved: (value) => description = value!.trim(),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter product description' : null,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Price'),
                    onSaved: (value) => price = value!.trim(),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Enter price' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Stock'),
                    onSaved: (value) => stock = value!.trim(),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Enter stock' : null,
                  ),
                  const SizedBox(height: 10),
                  _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : const Text('No image selected'),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.image),
                        label: const Text('Pick from Gallery'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera),
                        label: const Text('Take a Photo'),
                      ),
                    ],
                  ),
                  // TextFormField(
                  //   decoration: const InputDecoration(labelText: 'Image URL'),
                  //   onSaved: (value) => imageUrl = value!.trim(),
                  //   validator: (value) =>
                  //       value!.isEmpty ? 'Enter image URL' : null,
                  // ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    items: categories
                        .map(
                          (cat) => DropdownMenuItem<int>(
                            value: cat.id,
                            child: Text(cat.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() {
                      selectedCategoryId = value;
                    }),
                    validator: (value) =>
                        value == null ? 'Select a category' : null,
                    decoration: const InputDecoration(
                      labelText: 'Select Category',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : _submitForm,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                        : const Text('Add Product'),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Text('Error loading categories: $err'),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => isLoading = true);

    if (_imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No image selected')));
      return;
    }

    final token = ref.read(authTokenProvider) ?? '';

    final streamedResponse = await ProductApi.addProduct(
      name: name,
      price: price,
      stock: stock,
      description: description,
      image: _imageFile!,
      categoryId: selectedCategoryId!,
      token: token,
    );

    // ✅ Read response body from streamed response
    final response = await http.Response.fromStream(streamedResponse);

    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product added')));
      // ignore: unused_result
      ref.refresh(productProvider);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: ${response.body}')));
    }
  }
}
