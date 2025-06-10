import 'package:demo/controllers/user_controller.dart';
import 'package:demo/models/user.dart';
import 'package:demo/routes/web.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPage extends StatelessWidget {
   UserPage({Key? key}) : super(key: key);

  final UserController controller = Get.find() ;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Users'),

        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (controller.users.isEmpty) {
            return const Center(child: Text('No users found'));
          }
      
          return RefreshIndicator(
            onRefresh: controller.fetchUsers,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.users.length,
              itemBuilder: (context, index) {
                final user = controller.users[index];
                return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                    ),
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
                  user.name ?? 'No name',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getRoleColor(user.role?.name),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.role?.name!.toUpperCase() ?? 'NO ROLE',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Email row
            Row(
              children: [
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  user.email ?? 'No email',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Phone row
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(                  user.phone ?? 'Pas de numéro de téléphone',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            
            // Edit and Delete buttons
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: ()  {
                    controller.goToEdit(user);
                  },
                  child: const Text('MODIFIER'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                  
                    Get.defaultDialog(                  title: 'Supprimer l\'Utilisateur',
                  content: Text('Êtes-vous sûr de vouloir supprimer ${user.name}?'),
                  confirm: TextButton(
                    onPressed: () async {
                      Get.back();
                      await controller.deleteUser(user.id!);
                    },
                    child: const Text('SUPPRIMER', style: TextStyle(color: Colors.red)),
                  ),
                  cancel: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('ANNULER'),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('DELETE'),
                ),
              ],
            ),
                    ],
                  ),
                    ),
                  );},
            ),
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to create user page
            Get.toNamed(RouteClass.getCreateUserRoute());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Color _getRoleColor(String? roleName) {
    switch (roleName?.toLowerCase()) {
      case 'admin':
        return Colors.redAccent;
      case 'manager':
        return Colors.blueAccent;
      case 'user':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}