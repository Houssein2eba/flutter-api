// product_model.dart
import 'pivot.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final int minQuantity;
  final String? image;
  final Pivot pivot;
  final String createdAt;
  final double cost;
  final String updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.minQuantity,
    required this.image,
    required this.pivot,
    required this.createdAt,
    required this.cost,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: json['quantity']?.toInt() ?? 0,
      minQuantity: json['min_quantity']?.toInt() ?? 0,
      image: json['image'] ?? '',
      pivot: Pivot.fromJson(json['pivot']),
      createdAt: json['created_at'],
      cost: double.tryParse(json['cost']?.toString() ?? '0') ?? 0.0,
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'min_quantity': minQuantity,
      'image': image,
      'pivot': pivot.toJson(),
      'created_at': createdAt,
      'cost': cost,
      'updated_at': updatedAt,
    };
  }
}