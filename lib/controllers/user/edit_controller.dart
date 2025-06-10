import 'dart:convert';
import 'package:demo/routes/web.dart';
import 'package:demo/controllers/user_controller.dart';

import 'package:demo/models/user.dart';
import 'package:demo/services/stored_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:demo/core/functions/handle_validation.dart';
class EditUserController extends GetxController {
  final StorageService storage = Get.find();
  final UserController userController = Get.find();

  final RxBool isLoading = false.obs;
  final RxString selectedRoleId = ''.obs;
  User? user;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() async {
    super.onInit();
    user = Get.arguments['user'];
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    nameController.text = user?.name ?? '';
    emailController.text = user?.email ?? '';
    phoneController.text = user?.phone ?? '';
    selectedRoleId.value = user?.role?.id ?? '';
    await userController.fetchRoles();
  }

  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<void> updateUser({required String id}) async {
    if (!_validateForm()) return;

    isLoading.value = true;
    final token = storage.getToken();
    if (token == null) return;
    final response = await http.put(
      Uri.parse('http://192.168.100.13:8000/api/users/$id'),
      headers: _buildHeaders(token),
      body: json.encode({
        'name': nameController.text,
        'email': emailController.text,
        'number': phoneController.text,
        'role_id': selectedRoleId.value,
      }),
    );
    isLoading.value = false;

    if (response.statusCode == 200) {
      UsefulFunctions.showToast("Utilisateur mis à jour avec succès", "success");
      Get.toNamed(RouteClass.getUsersRoute());
      userController.fetchUsers();
    } else {
      UsefulFunctions.handleValidationErrors(response);
    }
  }

  bool _validateForm() {    if (!formKey.currentState!.validate()) {
      Get.snackbar('Erreur', 'Veuillez sélectionner un rôle');
      return false;
    } else {
      return true;
    }
  }



  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
