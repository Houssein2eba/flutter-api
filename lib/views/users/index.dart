import 'package:demo/controllers/user/user_controller.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/models/user.dart';
import 'package:demo/routes/web.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPage extends StatelessWidget {
  UserPage({super.key});

  final UserController controller = Get.find();
  


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Employés',
            style: TextStyle(
              color: AppColors.backgroundColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.backgroundColor),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: AppColors.backgroundColor),
              onPressed: controller.fetchUsers,
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          if (controller.users.isEmpty) {
            return Center(
              child: Text(
                'Aucun employé trouvé',
                style: TextStyle(
                  color: AppColors.lightTextColor,
                  fontSize: 16,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchUsers,
            color: AppColors.primaryColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.users.length,
              itemBuilder: (context, index) {
                final user = controller.users[index];
                return _buildUserCard(context, user);
              },
            ),
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(RouteClass.getCreateUserRoute());
          },
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, User user) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and Role row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.name ?? 'Non renseigné',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getRoleColor(user.role?.name),
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
            const SizedBox(height: 12),
            
            // Email row
            Row(
              children: [
                Icon(Icons.email, size: 16, color: AppColors.lightTextColor),
                const SizedBox(width: 8),
                Text(
                  user.email ?? 'Non renseigné',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Phone row
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: AppColors.lightTextColor),
                const SizedBox(width: 8),
                Text(
                  user.phone ?? 'Pas de numéro de téléphone',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            
            // Edit and Delete buttons
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => controller.goToEdit(user),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('MODIFIER'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _showDeleteDialog(user),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
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

  Color _getRoleColor(String? roleName) {
    switch (roleName?.toLowerCase()) {
      case 'admin':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteDialog(User user) {
    Get.defaultDialog(
      title: 'Supprimer l\'Utilisateur',
      titleStyle: TextStyle(
        color: AppColors.textColor,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      content: Text(
        'Êtes-vous sûr de vouloir supprimer ${user.name}?',
        style: TextStyle(color: AppColors.lightTextColor),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
        onPressed: () async {
          Get.back();
          await controller.deleteUser(user.id!);
        },
        child: const Text(
          'SUPPRIMER',
          style: TextStyle(color: Colors.white),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'ANNULER',
          style: TextStyle(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}