import 'dart:convert';

import '../utils/constants.dart';

/// The three possible stock states shown in the UI.
enum StockStatus { inStock, lowStock, outOfStock }

/// A single product in the shop's inventory.
class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String category; // optional, empty string if not provided

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.category = '',
  });

  /// Works out the stock status using the documented threshold.
  StockStatus get status {
    if (quantity <= 0) return StockStatus.outOfStock;
    if (quantity <= lowStockThreshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  /// Returns a copy with some fields changed.
  /// Used for edits and +/- quantity changes (we never mutate a product).
  Product copyWith({
    String? name,
    double? price,
    int? quantity,
    String? category,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
    );
  }

  /// Converts a Product to a Map so it can be saved as JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'quantity': quantity,
        'category': category,
      };

  /// Rebuilds a Product from a saved Map.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      category: (json['category'] as String?) ?? '',
    );
  }

  /// Encodes a whole list of products into one JSON string.
  static String encodeList(List<Product> products) {
    return jsonEncode(products.map((p) => p.toJson()).toList());
  }

  /// Decodes a JSON string back into a list of products.
  static List<Product> decodeList(String source) {
    final List<dynamic> decoded = jsonDecode(source) as List<dynamic>;
    return decoded
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}