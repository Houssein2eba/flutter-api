import 'package:demo/controllers/role/roles_controller.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RolesTable extends GetView<RolesController> {
  const RolesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<RolesController>(
        builder: (controller) {
          if (controller.roles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No roles found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Create a new role to get started',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.roles.length,
            itemBuilder: (context, index) {
              final role = controller.roles[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text(role.name ?? 'No name'),
                  subtitle: Text("employees: ${role.usersCount}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: AppColors.primaryColor),
                        onPressed: (){},
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deleteRole(role.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}