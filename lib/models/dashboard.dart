

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
    totalProducts: int.tryParse(json['totalProducts'].toString()) ?? 0,
    lowStockCount: int.tryParse(json['lowStockCount'].toString()) ?? 0,
    totalSales: int.tryParse(json['totalSales'].toString()) ?? 0,
    clientCount: int.tryParse(json['clientCount'].toString()) ?? 0,
    stocksCount: int.tryParse(json['stocksCount'].toString()) ?? 0,
    totalCategories: int.tryParse(json['totalCategories'].toString()) ?? 0,
    totalRevenue: double.tryParse(json['totalRevenue'].toString()) ?? 0.0,
    totalProfit: double.tryParse(json['totalProfit'].toString()) ?? 0.0,
    todaySales: int.tryParse(json['todaySales'].toString()) ?? 0,
    todayRevenue: double.tryParse(json['todayRevenue'].toString()) ?? 0.0,
    dueAmount: double.tryParse(json['dueAmount'].toString()) ?? 0.0,
    paidAmount: double.tryParse(json['paidAmount'].toString()) ?? 0.0,
    );
  }
}
