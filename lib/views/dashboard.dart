import 'package:demo/controllers/auth_controller.dart';
import 'package:demo/routes/web.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/services/stored_service.dart';
import 'package:demo/controllers/dasboard/dashboard_controller.dart';

import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller = Get.find();
  final StorageService storage = Get.find();
  final Authcontroller authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  Drawer(
      child: Column(
        children: [
          // User Accounts Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text(
              storage.getUser()?.name ?? 'Unknown',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(storage.getUser()?.email ?? 'Unknown'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                // Replace with your image using:
                // child: Image.network('your_image_url', fit: BoxFit.cover)
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.work),
                  title: const Text('Employees'),
                  onTap: () {
                    // dashboardController.fetchDashboard();
                    Get.toNamed(RouteClass.getUsersRoute());
                    // Navigate to home
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Clients'),
                  onTap: () {
                    Get.toNamed(RouteClass.getHomeRoute());
                    // Navigate to profile
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.inventory),
                  title: const Text('Stocks'),
                  onTap: () {
                    Get.toNamed( RouteClass.getStocksRoute());
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help & Feedback'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to help
                  },
                ),
              ],
            ),
          ),

          // Logout Button at bottom
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async{
                  await authController.logout();
                },
              ),
            ),
          ),
        ],
      ),
    )
  ,
      appBar: AppBar(
        
        title: Text('Dashboard', 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          _buildNotificationIcon()
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerLoading();
        }
        
        if (controller.dashboard.value == null) {
          return _buildErrorState();
        }
        
        return RefreshIndicator(
          onRefresh: () => controller.fetchDashboard(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Inventory Summary
                _DashboardCard(
                  title: "Inventory Summary",
                  children: [
                    _StatItem(icon: Icons.group, color: Colors.green, label: 'Clients', value: controller.dashboard.value!.clientCount.toString()),
                    _StatItem(
                      icon: Icons.inventory_2_rounded,
                      color: Colors.blue,
                      label: "Total Products",
                      value: controller.dashboard.value!.totalProducts.toString(),
                    ),
                    _StatItem(
                      icon: Icons.warning_amber_rounded,
                      color: Colors.orange,
                      label: "Low Products",
                      value: controller.dashboard.value!.lowStockCount.toString(),
                    ),
                    _StatItem(
                      icon: Icons.inventory_sharp,
                      color: Colors.red,
                      label: "Stocks",
                      value: controller.dashboard.value!.stocksCount.toString()
                    ),
                    _StatItem(
                      icon: Icons.category_rounded,
                      color: Colors.purple,
                      label: "Categories",
                      value: controller.dashboard.value!.totalCategories.toString(),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Sales Overview
                _DashboardCard(
                  title: "Sales Overview",
                  children: [
                    _StatItem(
                      icon: Icons.shopping_cart_rounded,
                      color: Colors.green,
                      label: "Total Sales",
                      value: controller.dashboard.value!.totalSales.toString(),
                    ),
                    _StatItem(
                      icon: Icons.today_rounded,
                      color: Colors.amber,
                      label: "Today's Sales",
                      value: controller.dashboard.value!.todaySales.toString(),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Financial Summary
                _DashboardCard(
                  title: "Financial Summary",
                  children: [
                                        _StatItem(
                      icon: Icons.money_rounded,
                      color: Colors.red,
                      label: "Today's Revenue",
                      value: "${controller.dashboard.value!.totalRevenue?.toStringAsFixed(2) ?? '0.00'} MRU",
                      isCurrency: true,
                    ),
                    _StatItem(
                      icon: Icons.attach_money_rounded,
                      color: Colors.teal,
                      label: "Total Revenue",
                      value: "${controller.dashboard.value!.todayRevenue?.toStringAsFixed(2) ?? '0.00'} MRU",
                      isCurrency: true,
                    ),
                    _StatItem(
                      icon: Icons.account_balance_wallet_rounded,
                      color: Colors.green,
                      label: "Paid Amount",
                      value: "${controller.dashboard.value!.paidAmount?.toStringAsFixed(2) ?? '0.00'} MRU",
                      isCurrency: true,
                    ),
                    _StatItem(
                      icon: Icons.receipt_long_rounded,
                      color: Colors.orange,
                      label: "Unpaid Amount",
                      value: "${controller.dashboard.value!.dueAmount?.toStringAsFixed(2) ?? '0.00'} MRU",
                      isCurrency: true,
                    ),
                    _StatItem(
                      icon: Icons.trending_up_rounded,
                      color: Colors.indigo,
                      label: "Total Profit",
                      value: "${controller.dashboard.value!.totalProfit?.toStringAsFixed(2) ?? '0.00'} MRU",
                      isCurrency: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: List.generate(3, (index) => Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.only(bottom: 16),
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Failed to load dashboard data',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.fetchDashboard(),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}

Widget _buildNotificationIcon() {
    return IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {
        // Handle notification icon tap
        Get.toNamed('/notifications');
      },
    );
  }


class _DashboardCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DashboardCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: children,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final bool isCurrency;

  const _StatItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    this.isCurrency = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    
  }

}