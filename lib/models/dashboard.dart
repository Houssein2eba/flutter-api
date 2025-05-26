

class Dashboard {
  final int? totalProducts;
  final int? stocksCount;

  final int? clientCount;
  final int? lowStockCount;
  final int? totalSales;
  final int? totalCategories;
  final double? totalRevenue;
  final double? totalProfit;
  final int? todaySales;
  final double? todayRevenue;
  final double? paidAmount;
  final double? dueAmount;

  Dashboard({
    required this.totalProducts,
    required this.lowStockCount,
    required this.clientCount,
    required this.totalSales,
    required this.totalCategories,
    required this.totalRevenue,
    required this.totalProfit,
    required this.todaySales,
    required this.todayRevenue,
    required this.paidAmount,
    required this.dueAmount,
    required this.stocksCount,

  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      totalProducts: json['totalProducts'] ?? 0,
      lowStockCount: json['lowStockCount'] ?? 0,

      totalSales: json['totalSales'] ?? 0,
      clientCount: json['clientCount'] ?? 0,
      stocksCount: json['stocksCount'] ?? 0,
      totalCategories: json['totalCategories'] ?? 0,
      totalRevenue: (json['todayRevenue'] ?? 0).toDouble(),
      totalProfit: (json['totalProfit'] ?? 0).toDouble(),
      todaySales: json['todaySales'] ?? 0,
      todayRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      dueAmount: (json['dueAmount'] ?? 0).toDouble(),
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
    );
  }
}
