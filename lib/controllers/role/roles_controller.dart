import 'package:demo/core/class/status_request.dart';
import 'package:demo/core/functions/handeling_data.dart';
import 'package:demo/data/remote/roles_data.dart';
import 'package:demo/models/role.dart';
import 'package:demo/wigets/tost.dart';
import 'package:get/get.dart';

class RolesController extends GetxController {
  List<Role> roles = <Role>[];
  RolesData rolesData = RolesData(Get.find());
  int rolesCount = 0;
  StatusRequest statusRequest = StatusRequest.none;

  @override
  void onInit() {
    super.onInit();
    fetchRoles();
  }

  Future<void> fetchRoles() async {
    try {
      statusRequest = StatusRequest.loading;
      update();

      final response = await rolesData.getRoles();
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        roles.clear();
        print(response['roles_count'].runtimeType);
        rolesCount = response['roles_count'];

        for (var role in response['roles']) {
          print(role);
          roles.add(Role.fromJson(role));
        }

        if (roles.isEmpty) {
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération des rôles: $e');
      statusRequest = StatusRequest.failure;
    }

    update();
  }

  Future<void> deleteRole(String id) async {
    try {
      statusRequest = StatusRequest.loading;
      update();

      final response = await rolesData.deleteRole(id);
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        roles.removeWhere((role) => role.id == id);
        fetchRoles();
        showToast("Role deleted successfully", "success");
        update();
      }
    } catch (e) {
      statusRequest = StatusRequest.serverFailure;
      showToast("Error deleting role: $e", "error");
      update();
    }
    update();
  }
}
