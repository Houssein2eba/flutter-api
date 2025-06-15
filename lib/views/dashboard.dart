import 'package:demo/controllers/auth_controller.dart';
import 'package:demo/core/constant/colors_class.dart';
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
      backgroundColor: AppColors.backgroundColor,
      drawer: Drawer(
        child: Column(
          children: [
            // User Accounts Drawer Header with gradient
            UserAccountsDrawerHeader(
              accountName: Text(
                storage.getUser()?.name ?? 'Inconnu',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                storage.getUser()?.email ?? 'Inconnu',
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.work,
                    title: 'Employés',
                    onTap: () => Get.toNamed(RouteClass.getUsersRoute()),
                  ),
                  _buildDrawerItem(
                    icon: Icons.supervisor_account,
                    title: 'Roles et Permissions',
                    onTap: () => Get.toNamed(RouteClass.roles),
                  ),
                  _buildDrawerItem(
                    icon: Icons.group,
                    title: 'Clients',
                    onTap: () => Get.toNamed(RouteClass.getHomeRoute()),
                  ),
                  _buildDrawerItem(
                    icon: Icons.inventory,
                    title: 'Stocks',
                    onTap: () => Get.toNamed(RouteClass.getStocksRoute()),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                    height: 20,
                  ),
                  _buildDrawerItem(
                    icon: Icons.help,
                    title: 'Aide & Retour',
                    onTap: () => Get.toNamed(RouteClass.stockMovements),
                  ),
                ],
              ),
            ),

            // Logout Button at bottom
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Déconnexion',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    await authController.logout();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Tableau de Bord',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.backgroundColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.backgroundColor),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: AppColors.backgroundColor),
            onPressed: () => Get.toNamed('/notifications'),
          ),
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
          color: AppColors.primaryColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Inventory Summary
                _DashboardCard(
                  title: "Résumé de l'Inventaire",
                  children: [
                    _StatItem(
                      icon: Icons.group,
                      color: AppColors.greenColor,
                      label: 'Clients',
                      value: controller.dashboard.value!.clientCount.toString(),
                    ),
                    _StatItem(
                      icon: Icons.inventory_2_rounded,
                      color: AppColors.primaryColor,
                      label: "Produits Totaux",
                      value: controller.dashboard.value!.totalProducts.toString(),
                    ),
                    _StatItem(
                      icon: Icons.warning_amber_rounded,
                      color: AppColors.accentColor,
                      label: "Produits Faibles",
                      value: controller.dashboard.value!.lowStockCount.toString(),
                    ),
                    _StatItem(
                      icon: Icons.inventory_sharp,
                      color: AppColors.secondaryColor,
                      label: "Stocks",
                      value: controller.dashboard.value!.stocksCount.toString(),
                    ),
                    _StatItem(
                      icon: Icons.category_rounded,
                      color: AppColors.purpleColor,
                      label: "Catégories",
                      value: controller.dashboard.value!.totalCategories.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Sales Overview
                _DashboardCard(
                  title: "Aperçu des Ventes",
                  children: [
                    _StatItem(
                      icon: Icons.shopping_cart_rounded,
                      color: AppColors.greenColor,
                      label: "Ventes Totales",
                      value: controller.dashboard.value!.totalSales.toString(),
                    ),
                    _StatItem(
                      icon: Icons.today_rounded,
                      color: AppColors.accentColor,
                      label: "Ventes du Jour",
                      value: controller.dashboard.value!.todaySales.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Financial Summary
                _DashboardCard(
                  title: "Résumé Financier",
                  children: [
                    _StatItem(
                      icon: Icons.money_rounded,
                      color: Colors.red,
                      label: "Revenus du Jour",
                      value:
                          "${controller.dashboard.value!.totalRevenue?.toStringAsFixed(2) ?? '0.00'} MRU",
                      isCurrency: true,
                    ),
                    _StatItem(
                      icon: Icons.attach_money_rounded,
                      color: AppColors.primaryColor,
                      label: "Revenus Totaux",
                      value:
                          "${controller.dashboard.value!.todayRevenue?.toStringAsFixed(2) ?? '0.00'} MRU",
                      isCurrency: true,
                    ),
                    _StatItem(
                      icon: Icons.account_balance_wallet_rounded,
                      color: AppColors.greenColor,
                      label: "Montant Payé",
                      value:
                          "${controller.dashboard.value!.paidAmount?.toStringAsFixed(2) ?? '0.00'} MRU",
                      isCurrency: true,
                    ),
                    _StatItem(
                      icon: Icons.receipt_long_rounded,
                      color: AppColors.accentColor,
                      label: "Montant Non Payé",
                      value:
                          "${controller.dashboard.value!.dueAmount?.toStringAsFixed(2) ?? '0.00'} MRU",
                      isCurrency: true,
                    ),
                    _StatItem(
                      icon: Icons.trending_up_rounded,
                      color: AppColors.secondaryColor,
                      label: "Profit Total",
                      value:
                          "${controller.dashboard.value!.totalProfit?.toStringAsFixed(2) ?? '0.00'} MRU",
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

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(
        title,
        style: TextStyle(color: AppColors.textColor),
      ),
      onTap: onTap,
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(
            3,
            (index) => Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                ),
              ],
            ),
          ),
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
          const SizedBox(height: 16),
          Text(
            'Échec du chargement des données du tableau de bord',
            style: TextStyle(fontSize: 18, color: AppColors.textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => controller.fetchDashboard(),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
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
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
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
                  style: const TextStyle(
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