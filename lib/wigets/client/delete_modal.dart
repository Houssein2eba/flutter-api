import 'package:demo/controllers/client/client_controller.dart';
import 'package:demo/core/constant/colors_class.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DeleteModal extends GetView<Clientscontroller> {
  final String clientName;
  final String clientId;
  const DeleteModal({super.key, required this.clientName, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                'Êtes-vous sûr de vouloir supprimer $clientName ?\nCette action est irréversible.',
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
                        await controller.deleteClient(id: clientId);
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
    
    );
  }
}
