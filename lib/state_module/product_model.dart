import 'dart:convert';

class Category {
  final int id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final List<String> images;
  final Category category;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : <String>[],
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : Category(id: 0, name: '', image: ''),
    );
  }
}

List<ProductModel> productModelFromJson(String jsonString) {
  final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
  return jsonList.map((json) => ProductModel.fromJson(json)).toList();
}
