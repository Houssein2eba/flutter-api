import 'dart:convert';

import 'package:demo/models/role.dart';
import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RoleController extends GetxController {
  final RxList roles = [].obs;
  final selectedRoleId = ''.obs;
  final RxBool isLoading = false.obs;
  final StorageService storage = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchRoles();
  }

  Future<void> fetchRoles() async {
    try {
      
      final token = storage.getToken();
      if (token == null) {
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }
      final response = await http.get(
        Uri.parse('http://192.168.100.13:8000/api/roles'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List rolesData = data['roles'];
      
        roles.assignAll(rolesData);
        
      } else {
        Get.snackbar('Error', 'faild to load data');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      
    }
  }
}
