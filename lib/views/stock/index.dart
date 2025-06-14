import 'package:demo/controllers/stock/stocks_controller.dart';
import 'package:demo/core/functions/handle_validation.dart';
import 'package:demo/models/stock.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockCard extends StatefulWidget {
  const StockCard({super.key});

  @override
  _StockCardState createState() => _StockCardState();
}

class _StockCardState extends State<StockCard> {
  final StocksController controller = Get.find();
  late final ScrollController scrollController;

  // Custom color palette matching login screen
  final Color primaryColor = const Color(0xFF6C63FF);
  final Color secondaryColor = const Color(0xFF4A40BF);
  final Color accentColor = const Color(0xFFF8B400);
  final Color backgroundColor = const Color(0xFFF9F9F9);
  final Color textColor = const Color(0xFF333333);
  final Color lightTextColor = const Color(0xFF777777);

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    if (controller.stocks.isEmpty) {
      controller.loadStocks();
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients || 
        controller.isLoadingMore.value || 
        !controller.hasMore.value) {
      return;
    }

    final threshold = 0.8 * scrollController.position.maxScrollExtent;
    final currentPosition = scrollController.position.pixels;

    if (currentPosition > threshold) {
      controller.loadStocks(loadMore: true);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Vue d\'ensemble des Stocks',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.stocks.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.loadStocks();
                },
                color: primaryColor,
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: controller.stocks.length + (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= controller.stocks.length) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                      );
                    }

                    final stock = controller.stocks[index];
                    return _buildStockCard(stock);
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStockCard(Stock stock) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to details page
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.inventory,
                              size: 28,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stock.name ?? 'Non spécifié',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                stock.location ?? 'Localisation inconnue',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: lightTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: stock.status == 'good'
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          stock.status ?? 'Inconnu',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: stock.status == 'good'
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 1.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: [
                      _buildStatItem(
                        'Types de Produits',
                        '${stock.productTypes ?? 0}',
                      ),
                      _buildStatItem(
                        'Nombre de Produits',
                        '${stock.totalProducts ?? 0}',
                      ),
                      _buildStatItem(
                        'Valeur Totale',
                        '\$${(stock.totalValue ?? 0).toStringAsFixed(2)}',
                      ),
                      _buildStatItem(
                        'Dernière Mise à Jour',
                        UsefulFunctions.formatDate(stock.updatedAt),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: lightTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}