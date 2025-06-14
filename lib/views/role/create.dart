import 'package:demo/controllers/role/create_role_controller.dart';
import 'package:demo/core/class/status_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateRoleView extends StatelessWidget {
  CreateRoleView({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Get.put(CreateRoleController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Role'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Get.find<CreateRoleController>().createRole();
              }
            },
          ),
        ],
      ),
      body: GetBuilder<CreateRoleController>(
        builder: (controller) {
          if (controller.statusRequest == StatusRequest.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.roleNameController,
                    decoration: const InputDecoration(labelText: 'Role Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a role name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Permissions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.permissions.length,
                      itemBuilder: (context, index) {
                        final permission = controller.permissions[index];
                        return CheckboxListTile(
                          title: Text(permission.name),
                          value: controller.selectedPermissions
                              .contains(permission.id.toString()),
                          onChanged: (bool? value) {
                            controller.togglePermission(permission.id.toString());
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}