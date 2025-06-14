import 'package:demo/controllers/order/single_order_controller.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/models/order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientDetailsPage extends StatelessWidget {
  final SingleOrderController controller = Get.find();




  ClientDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Détails du Client',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          // Safe access to client data (might be empty)
          final client = controller.orderDetails.isNotEmpty 
              ? controller.orderDetails.first.client 
              : null;

          return SingleChildScrollView(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Client Information Section
                if (client != null)
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            client.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(Icons.phone, client.phone),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Orders Section Header
                Text(
                  'Historique des Commandes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 8),

                // Orders List or Empty State
                if (controller.orderDetails.isEmpty)
                  _buildNoOrdersFound()
                else
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.orderDetails.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = controller.orderDetails[index];
                      return _buildOrderCard(order, context);
                    },
                  ),
                  controller.isLoadingMore.value
                    ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                    : const SizedBox.shrink(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNoOrdersFound() {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: AppColors.lightTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune Commande Trouvée',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ce client n\'a pas encore d\'historique de commandes',
            style: TextStyle(
              color: AppColors.lightTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.lightTextColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: AppColors.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order, BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Commande #${order.reference}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    order.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.picture_as_pdf, color: Colors.red[400]),
                    onPressed: () async {
                      await controller.exportPdf(id: order.id);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(height: 24, color: Colors.grey[200]),

            Text(
              'Date: ${order.createdAt}',
              style: TextStyle(color: AppColors.lightTextColor),
            ),
            const SizedBox(height: 12),
            
            // Products List
            if (order.products.isNotEmpty)
              ...order.products.map((product) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${product.pivot.quantity} x ${product.name}',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                  ],
                ),
              )),
            
            Divider(height: 24, color: Colors.grey[200]),
            
            // Order Total and Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                order.status == 'paid' 
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : ElevatedButton(
                        onPressed: () async {
                          await controller.markAsPaid(id: order.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Marquer comme Payé'),
                      ),
                
                Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return AppColors.accentColor;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.lightTextColor;
    }
  }
}