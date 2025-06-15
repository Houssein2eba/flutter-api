import 'package:demo/controllers/client/client_controller.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/models/client.dart';
import 'package:demo/routes/web.dart';
import 'package:demo/wigets/client/edit_delete.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ClientCard extends GetView<Clientscontroller> {
  final Client client;
  const ClientCard({super.key,required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _navigateToClientDetails(client.id),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Modern Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      client.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Client Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_rounded,
                            size: 16,
                            color: AppColors.lightTextColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            client.phone,
                            style: TextStyle(
                              color: AppColors.lightTextColor,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                EditDeleteButtons(client: client),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToClientDetails(String clientId) {
    Get.toNamed(RouteClass.getShowClientRoute(), arguments: {'id': clientId});
  }
}
