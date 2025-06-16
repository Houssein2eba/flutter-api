import 'package:demo/controllers/role/roles_controller.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/models/client.dart';
import 'package:demo/models/role.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class EditDeleteButtons extends GetView<RolesController> {
  final Role role;
  const EditDeleteButtons({super.key,required this.role});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<RolesController>(
      builder: (controller) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () =>{},
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Delete Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _showModernDeleteDialog(role.id!, role.name!),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.delete_rounded,
                    color: Colors.red[600],
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  void _showModernDeleteDialog(String roleId, String roleName) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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
                'Supprimer le client',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Content
              Text(
                'Êtes-vous sûr de vouloir supprimer le role $roleName ?\nCette action est irréversible.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.lightTextColor,
                  fontSize: 16,
                ),
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
                          await Future.delayed(const Duration(milliseconds: 200));
                        }
                        await controller.deleteRole( roleId);
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
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
