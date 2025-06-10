import 'dart:convert';
import 'package:demo/models/role.dart';
import 'package:demo/models/user.dart';
import 'package:demo/routes/web.dart';
import 'package:demo/services/stored_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../core/functions/handle_validation.dart';

class UserController extends GetxController {
  final StorageService storage = Get.find();
  
  final RxList<User> users = <User>[].obs;
  final RxList<Role?> roles = <Role?>[].obs;
  final RxBool isLoading = false.obs;
  var selectedRoleId = ''.obs;
   late  final TextEditingController nameController ;
 late  final TextEditingController emailController;
  late TextEditingController phoneController ;
late  final TextEditingController passwordController ;
late  final TextEditingController confirmPasswordController ;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  get formkey=> _formKey;
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  @override
  void onInit() async {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    await fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    await Future.wait([fetchUsers(), fetchRoles()]);
  }

  Future<List<Role?>?> fetchRoles() async {
    try {
      
      final token = storage.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('http://192.168.100.13:8000/api/roles'),
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rolesData = data['roles'] as List;
        roles.value = rolesData.map((r) => Role.fromJson(r)).toList();
        return roles;
      }
      return null;
    } finally {
      
    }
  }

  Future<void> fetchUsers() async {
    try {
      isLoading(true);
      final token = storage.getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse('http://192.168.100.13:8000/api/users'),
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        users.value = (data['users'] as List)
            .map((user) => User.fromJson(user))
            .toList();
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      isLoading(true);
      final response = await http.delete(
        Uri.parse('http://192.168.100.13:8000/api/users/$id'),
        headers: _buildHeaders(storage.getToken()!),
      );

      if (response.statusCode == 200) {
        users.removeWhere((user) => user.id == id);
        Get.snackbar('Success', 'User deleted successfully');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateUser({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String roleId,
  }) async {
    try {
      isLoading(true);
      final token = storage.getToken();
      if (token == null) return;

      final response = await http.put(
        Uri.parse('http://192.168.100.13:8000/api/users/$id'),
        headers: _buildHeaders(token),
        body: jsonEncode({
          'name': name,
          'email': email,
          'number': phone,
          'role_id': roleId,
        }),
      );

      if (response.statusCode == 200) {
        await fetchUsers();
        Get.snackbar('Success', 'User updated successfully');
      } else if (response.statusCode == 422) {
        _handleValidationErrors(response);
      }
    } finally {
      isLoading(false);
    }
  }

  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  void _handleValidationErrors(http.Response response) {
    final data = json.decode(response.body);
    final errors = data['errors'] as Map<String, dynamic>;
    final errorMessage = errors.entries
        .map((e) => '${e.key}: ${e.value.join(', ')}')
        .join('\n');
    Get.snackbar('Erreur de Validation', errorMessage);
  }

  Future<bool> createEmployee() async {
    try {
      final token = storage.getToken();      if (token == null) {
        Get.snackbar('Erreur', 'Jeton d\'authentification non trouvé');
        return false;
      }
      Get.dialog(
        const CircularProgressIndicator(),
        barrierDismissible: false,
      );

      final response = await http.post(
        Uri.parse('http://192.168.100.13:8000/api/users'),
        headers: _buildHeaders(token),
        body: jsonEncode({
          'name': nameController.text,
          'email': emailController.text,
          'number': phoneController.text,
          'password': passwordController.text,
          'role_id': selectedRoleId.value,
        }),
      );
      Get.back(); // Close the loading dialog

      if (response.statusCode == 200) {        UsefulFunctions.showToast(
          'Employé créé avec succès',
          'success',
        );
        await fetchUsers();

        return true;
      } else if (response.statusCode == 422) {
        _handleValidationErrors(response);
        return false;
      } else {      Get.snackbar(
        'Erreur',
        'Échec de la création de l\'employé ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      Get.back(); // Close the loading dialog
      Get.snackbar('Error', e.toString());
    }
    return false;
  }

goToEdit(User user){
  Get.toNamed(RouteClass.getEditUserRoute(),arguments: {'user':user});
}

}

