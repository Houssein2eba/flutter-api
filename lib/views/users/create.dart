import 'package:demo/core/constant/colors_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/user/user_controller.dart';

class CreateUser extends StatelessWidget {
  CreateUser({super.key});
  final UserController controller = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Nouvel Employé',
          style: TextStyle(
            color: AppColors.backgroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildFormFields(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_add_alt_1,
            size: 32,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Ajouter un nouvel employé',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Veuillez remplir les informations de l'employé",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.lightTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: 'Nom complet',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            prefixIcon: Icon(Icons.person_outline, color: AppColors.lightTextColor),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer le nom complet' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Adresse e-mail',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            prefixIcon: Icon(Icons.email_outlined, color: AppColors.lightTextColor),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return "Veuillez entrer l'adresse e-mail";
            if (!value!.contains('@')) return 'Veuillez entrer une adresse e-mail valide';
            return null;
          },
        ),
        const SizedBox(height: 16),
        Obx(() => TextFormField(
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: TextStyle(color: AppColors.lightTextColor),
                prefixIcon: Icon(Icons.lock_outline, color: AppColors.lightTextColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value 
                        ? Icons.visibility 
                        : Icons.visibility_off,
                    color: AppColors.lightTextColor,
                  ),
                  onPressed: () => controller.isPasswordVisible.toggle(),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Veuillez entrer un mot de passe';
                if (value!.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères';
                return null;
              },
            )),
        const SizedBox(height: 16),
        Obx(() => TextFormField(
              controller: controller.confirmPasswordController,
              obscureText: !controller.isConfirmPasswordVisible.value,
              decoration: InputDecoration(
                labelText: 'Confirmer le mot de passe',
                labelStyle: TextStyle(color: AppColors.lightTextColor),
                prefixIcon: Icon(Icons.lock_outline, color: AppColors.lightTextColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordVisible.value 
                        ? Icons.visibility 
                        : Icons.visibility_off,
                    color: AppColors.lightTextColor,
                  ),
                  onPressed: () => controller.isConfirmPasswordVisible.toggle(),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Veuillez confirmer le mot de passe';
                if (value != controller.passwordController.text) return 'Les mots de passe ne correspondent pas';
                return null;
              },
            )),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Numéro de téléphone',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            prefixIcon: Icon(Icons.phone_outlined, color: AppColors.lightTextColor),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Veuillez entrer le numéro de téléphone';
            if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value!)) {
              return 'Veuillez entrer un numéro valide';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedRoleId.value.isEmpty ? null : controller.selectedRoleId.value,
              decoration: InputDecoration(
                labelText: 'Rôle',
                labelStyle: TextStyle(color: AppColors.lightTextColor),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
                ),
              ),
              items: controller.roles.map((role) {
                return DropdownMenuItem<String>(
                  value: role!.id.toString(),
                  child: Text(role.name!),
                );
              }).toList(),
              validator: (value) => value == null ? 'Veuillez sélectionner un rôle' : null,
              onChanged: (value) {
                if (value != null) {
                  controller.selectedRoleId.value = value;
                }
              },
              isExpanded: true,
              hint: Text(
                'Sélectionnez un rôle',
                style: TextStyle(color: AppColors.lightTextColor),
              ),
              dropdownColor: Colors.white,
              style: TextStyle(color: AppColors.textColor),
            )
            ),
            
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (controller.formkey.currentState!.validate()) {
            if (controller.selectedRoleId.value.isEmpty) {
              Get.snackbar(
                'Erreur',
                'Veuillez sélectionner un rôle',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red[400],
                colorText: Colors.white,
              );
              return;
            }

            final success = await controller.createEmployee();

            if (success) {
              Get.back();
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Créer l'employé",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}