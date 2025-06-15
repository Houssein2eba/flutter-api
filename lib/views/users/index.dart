import 'package:demo/controllers/user/user_controller.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/core/widgets/loadin_indicator.dart';
import 'package:demo/core/widgets/silver_appbar.dart';
import 'package:demo/core/widgets/custom_floating.dart';
import 'package:demo/models/user.dart';
import 'package:demo/routes/web.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPage extends StatelessWidget {
  UserPage({super.key});

  final UserController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: CustomFloatingAction(
        onPressed: () {
          Get.toNamed(RouteClass.getCreateUserRoute());
        },
      ),
      body: CustomScrollView(
        slivers: [
          CustomSilverAppbar(title: 'Employés'),
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadinIndicator();
              }

              if (controller.users.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Aucun employé trouvé',
                      style: TextStyle(
                        color: AppColors.lightTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchUsers,
                color: AppColors.primaryColor,
                child: _buildUserList(),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ...controller.users.map((user) => _buildUserCard(user)).toList(),
          const SizedBox(height: 80), // Space for floating button
        ],
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    user.name ?? 'Non renseigné',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.role?.name?.toUpperCase() ?? 'AUCUN RÔLE',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // User details
            _buildUserDetail(
              icon: Icons.email,
              label: 'Email',
              value: user.email ?? 'Non renseigné',
            ),
            const SizedBox(height: 12),
            _buildUserDetail(
              icon: Icons.phone,
              label: 'Téléphone',
              value: user.phone ?? 'Pas de numéro',
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => controller.goToEdit(user),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
                  child: const Text('MODIFIER'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _showDeleteDialog(user),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.red),
                    ),
                  ),
                  child: const Text('SUPPRIMER'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.lightTextColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.lightTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



  void _showDeleteDialog(User user) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: Colors.red[600],
                  size: 40,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                "Supprimer l'Employé",

                style: TextStyle(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 12),

              // Content
              Text(
                'Êtes-vous sûr de vouloir supprimer ${user.name} ?\nCette action est irréversible.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.lightTextColor, fontSize: 16),
              ),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                          color: AppColors.lightTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (Get.isDialogOpen ?? false) {
                          Get.back();
                          await Future.delayed(
                            const Duration(milliseconds: 200),
                          );
                        }
                        await controller.deleteUser(
                           user.id!,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Supprimer',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    
    )
  
    );
  }
}