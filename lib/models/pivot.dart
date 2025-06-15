// pivot_model.dart
class Pivot {
  final String orderId;
  final String productId;
  final int quantity;
  final double totalAmount;
  final String createdAt;
  final String updatedAt;

  Pivot({
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity']?.toInt() ?? 0,
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'total_amount': totalAmount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}