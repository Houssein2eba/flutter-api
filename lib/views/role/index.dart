import 'package:demo/controllers/role/roles_controller.dart';
import 'package:demo/core/class/handeling_data_view.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/core/widgets/custom_floating.dart';
import 'package:demo/core/widgets/silver_appbar.dart';
import 'package:demo/routes/web.dart';
import 'package:demo/wigets/role/edit_delete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RolesScreen extends StatelessWidget {
  RolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RolesController controller = Get.put(RolesController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      floatingActionButton:CustomFloatingAction(onPressed: () {
        Get.toNamed(RouteClass.crateRole);
      }),
      body: CustomScrollView(
        slivers: [
          CustomSilverAppbar(
            title: 'Les Rôles',
          
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: GetBuilder<RolesController>(
              builder: (_) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    // Stats Cards Row
                    _buildStatsSection(controller),
                    const SizedBox(height: 24),
                    
                    // Roles List
                    _buildRolesList(controller),
                  ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(RolesController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatCard('Les Rôles disponibles', controller.rolesCount.toString(), Icons.group),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 30, color: AppColors.primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRolesList(RolesController controller) {
    return HandlingDataView(
      statusRequest: controller.statusRequest,
      widget: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.list, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Liste des Rôles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.roles.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[200]),
              itemBuilder: (context, index) {
                final role = controller.roles[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  title: Text(
                    role.name!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Permissions: ${role.permissions?.length} \n Employés: ${role.usersCount}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: EditDeleteButtons(role: role),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, RolesController controller, String roleId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer ce rôle?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteRole(roleId);
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}