class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
      price: double.parse(json['price'].toString()),
      categoryId: json['category_id'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': imageUrl,
      'price': price,
      'category_id': categoryId,
    };
  }
}
