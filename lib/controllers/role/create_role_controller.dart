import 'package:demo/controllers/role/roles_controller.dart';
import 'package:demo/core/class/status_request.dart';
import 'package:demo/core/functions/handeling_data.dart';
import 'package:demo/core/functions/validation_errors.dart';
import 'package:demo/data/remote/roles_data.dart';
import 'package:demo/models/permission.dart';
import 'package:demo/routes/web.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateRoleController extends GetxController {
  late TextEditingController roleNameController;
  List<String> selectedPermissions = [];
  List<Permission> permissions = <Permission>[];
  StatusRequest statusRequest = StatusRequest.none;
  RolesData rolesData = RolesData(Get.find());

  @override
  void onInit() {
    super.onInit();
    roleNameController = TextEditingController();
    fetchPermissions();
  }

  Future<void> fetchPermissions() async {
    try {
      statusRequest = StatusRequest.loading;
      update();
      final response = await rolesData.getPermisssions();
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        permissions.clear();
        for (var permission in response['permissions']) {
          print("===permision name + ${permission['name']}");
          permissions.add(Permission.fromJson(permission));
        }
      }
      update();
    } catch (e) {
      print('Error fetching permissions: $e');
      statusRequest = StatusRequest.serverException;
      update();
    }
  }

  void togglePermission(String permissionId) {
    if (selectedPermissions.contains(permissionId)) {
      selectedPermissions.remove(permissionId);
    } else {
      selectedPermissions.add(permissionId);
    }
    update();
  }

Future<void> createRole() async {
  try {
    statusRequest = StatusRequest.loading;
    update();

    var response = await rolesData.createRole(
      role: roleNameController.text.trim(),
      perissions: selectedPermissions,
    );
    statusRequest = handlingData(response);

    if (statusRequest == StatusRequest.success) {
      Get.snackbar(
        'Succès',
        'Role est crée avec succès',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Just call fetchRoles() on the existing controller
      Get.find<RolesController>().fetchRoles();
      // Use offNamed to replace current route
      Get.until((route) => route.settings.name == RouteClass.roles);
    } else {
      handleValidationErrors(response);
    }
  } catch (e) {
    statusRequest = StatusRequest.serverException;
    Get.snackbar(
      'Erreur',
      'Une erreur s\'est produite lors de la création du rôle',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  update();
}
  @override
  void onClose() {
    roleNameController.dispose();
    super.onClose();
  }
}
