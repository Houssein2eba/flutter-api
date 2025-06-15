
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
productTypes: int.tryParse(json['productsCount'].toString()) ?? 0,
totalProducts: int.tryParse(json['totalProducts'].toString()) ?? 0,
totalValue: double.tryParse(json['totalValue'].toString()) ?? 0.0,
      updatedAt: json['updated_at'] ?? '',
    );
  }

}