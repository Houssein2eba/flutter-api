class StockMovement {
  final String id;
  final String productName;
  final String stockName;
  final String type; // 'in' or 'out'
  final int quantity;
  final DateTime stockDate;

  StockMovement({
    required this.id,
    required this.productName,
    required this.stockName,
    required this.type,
    required this.quantity,
    required this.stockDate,
  });

  factory StockMovement.fromJson(Map<String, dynamic> json) {
    return StockMovement(
      id: json['id'],
      productName: json['product_name'],
      stockName: json['stock_name'],
      type: json['type'],
      quantity: json['quantity'],
      stockDate: DateTime.parse(json['stock_date']),
    );
  }
}
