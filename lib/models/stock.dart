
class Stock {

    final String? id;
  final String? name;
  final String? location;
  final String? status;
  final int? productTypes;
  final int? totalProducts;
  final double? totalValue;
  final String updatedAt;

  Stock({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.productTypes,
    required this.totalProducts,
    required this.totalValue,
    required this.updatedAt,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? '',
      productTypes: json['productsCount'] ?? 0,
      totalProducts: json['totalProducts'] ?? 0,
      totalValue: (json['totalValue'] ?? 0).toDouble(),
      updatedAt: json['updated_at'] ?? '',
    );
  }

}