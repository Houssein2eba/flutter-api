import 'package:demo/controllers/order/ventes_controller.dart';
import 'package:demo/core/class/handeling_data_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StockMovementsScreen extends StatelessWidget {
  const StockMovementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StockMovementsController());
    return GetBuilder<StockMovementsController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text(
              'Stock Movements',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),
          body: Column(
            children: [
              // Filter Card with Glass Effect
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Filter Movements',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        // Type Filter
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: controller.typeFilter,
                              hint: Text(
                                'All Movement Types',
                                style: TextStyle(color: Colors.grey),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'in',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_downward,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Stock In'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'out',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_upward,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Stock Out'),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: controller.setTypeFilter,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        if (controller.typeFilter != null)
                          ElevatedButton(
                            onPressed: controller.clearFilters,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.blue,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.blue),
                              ),
                            ),
                            child: Text('Clear Filter'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Movements List
              Expanded(
                child: HandlingDataView(
                  statusRequest: controller.statusRequest,
                  widget: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.filteredMovements.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final movement = controller.filteredMovements[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: movement.type == 'in'
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              movement.type == 'in'
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: movement.type == 'in'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          title: Text(
                            movement.productName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                'Quantity: ${movement.quantity}',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              SizedBox(height: 2),
                              Text(
                                DateFormat('MMM dd, yyyy - hh:mm a')
                                    .format(movement.stockDate),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: movement.type == 'in'
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              movement.type == 'in' ? 'Entrée' : 'Sortie',
                              style: TextStyle(
                                color: movement.type == 'in'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}