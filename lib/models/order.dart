// order_model.dart
import 'product.dart';

import 'client.dart';


class Order {
  final String id;
  final String reference;
  final String status;
  final double totalAmount;
 
  final List<Product> products;
  final Client client;
  final int items;
  final String createdAt;
  final String updatedAt;

  Order({
    required this.id,
    required this.reference,
    required this.status,
    required this.totalAmount,
    
    required this.products,
    required this.client,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      reference: json['reference'],
      status: json['status'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      
      client: Client.fromJson(json['client']),
      products:
          (json['products'] as List)
              .map((product) => Product.fromJson(product))
              .toList(),
      items: json['items'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'status': status,
      'total_amount': totalAmount,
      
      'products': products.map((product) => product.toJson()).toList(),
      'items': items,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
  Order copyWith({String? id, String? reference, String? status, double? totalAmount, dynamic payment, List<Product>? products, Client? client, int? items, String? createdAt, String? updatedAt}) {
    return Order(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
    
      products: products ?? this.products,
      client: client ?? this.client,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
