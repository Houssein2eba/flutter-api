import 'package:demo/controllers/role/create_role_controller.dart';
import 'package:demo/core/class/status_request.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateRoleView extends StatelessWidget {
  CreateRoleView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Get.put(CreateRoleController());
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create New Role',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor:AppColors.primaryColor,
        elevation: 0,

      ),
      body: GetBuilder<CreateRoleController>(
        builder: (controller) {
          if (controller.statusRequest == StatusRequest.loading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role Name Field
                  Text(
                    'Role Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.roleNameController,
                    decoration: InputDecoration(
                      labelText: 'Role Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceVariant,
                      prefixIcon: const Icon(Icons.badge_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a role name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Permissions Section
                  Row(
                    children: [
                      Text(
                        'Permissions',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(
                          '${controller.selectedPermissions.length} selected',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        backgroundColor: theme.colorScheme.primaryContainer,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Select the permissions this role should have',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Permissions List
                  Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(12),
                      elevation: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ListView.separated(
                          itemCount: controller.permissions.length,
                          itemBuilder: (context, index) {
                            final permission = controller.permissions[index];
                            return Container(
                              color: theme.colorScheme.surface,
                              child: CheckboxListTile(
                                title: Text(
                                  formatPermissionLabel(permission.name),
                                  style: theme.textTheme.bodyMedium,
                                ),
                                value: controller.selectedPermissions
                                    .contains(permission.id.toString()),
                                onChanged: (bool? value) {
                                  controller.togglePermission(permission.id.toString());
                                },
                                secondary: Icon(
                                  _getPermissionIcon(permission.name),
                                  color: theme.colorScheme.primary,
                                ),
                                controlAffinity: ListTileControlAffinity.leading,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            thickness: 1,
                            color: theme.colorScheme.outline.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Create Button
                  if (controller.selectedPermissions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.createRole();
                            }
                          },
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Create Role'),
                        ),
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

  IconData _getPermissionIcon(String permissionName) {
    if (permissionName.toLowerCase().contains('creer')) return Icons.add_circle_outline;
    if (permissionName.toLowerCase().contains('voir')) return Icons.visibility_outlined;
    if (permissionName.toLowerCase().contains('modifier')) return Icons.edit_outlined;
    if (permissionName.toLowerCase().contains('supprimer')) return Icons.delete_outline;
    return Icons.lock_outline;
  }
  String formatPermissionLabel(String permissionKey) {
  // Ajoute un espace avant chaque majuscule et met en majuscule la première lettre
  String formatted = permissionKey.replaceAllMapped(
    RegExp(r'(?<=[a-z])[A-Z]'),
    (Match m) => ' ${m.group(0)}'
  );
  
  return formatted[0].toUpperCase() + formatted.substring(1);
}
}