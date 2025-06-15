import 'package:demo/controllers/user/user_controller.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/core/widgets/silver_appbar.dart';
import 'package:demo/wigets/special_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUser extends StatelessWidget {
  CreateUser({super.key});
  final UserController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          CustomSilverAppbar(title: 'Nouvel Employé'),
          SliverToBoxAdapter(
            child: _buildFormContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: controller.formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildNameField(),
            const SizedBox(height: 16),
            _buildEmailField(),
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 16),
            _buildConfirmPasswordField(),
            const SizedBox(height: 16),
            _buildPhoneField(),
            const SizedBox(height: 16),
            _buildRoleDropdown(),
            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add_alt_1,
              size: 40,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        Text(
          'Ajouter un nouvel employé',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Veuillez remplir les informations de l'employé",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.lightTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: 'Nom complet',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.person_outline, color: AppColors.lightTextColor),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer le nom complet' : null,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Adresse e-mail',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.email_outlined, color: AppColors.lightTextColor),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return "Veuillez entrer l'adresse e-mail";
            if (!value!.contains('@')) return 'Veuillez entrer une adresse e-mail valide';
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: controller.passwordController,
              obscureText: !controller.isPasswordVisible.value,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: TextStyle(color: AppColors.lightTextColor),
                border: InputBorder.none,
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
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Veuillez entrer un mot de passe';
                if (value!.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères';
                return null;
              },
            ),
          ),
        ));
  }

  Widget _buildConfirmPasswordField() {
    return Obx(() => Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: controller.confirmPasswordController,
              obscureText: !controller.isConfirmPasswordVisible.value,
              decoration: InputDecoration(
                labelText: 'Confirmer le mot de passe',
                labelStyle: TextStyle(color: AppColors.lightTextColor),
                border: InputBorder.none,
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
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Veuillez confirmer le mot de passe';
                if (value != controller.passwordController.text) return 'Les mots de passe ne correspondent pas';
                return null;
              },
            ),
          ),
        ));
  }

  Widget _buildPhoneField() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          maxLength: 8,
          decoration: InputDecoration(
            labelText: 'Numéro de téléphone',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.phone_outlined, color: AppColors.lightTextColor),
            counterText: '',
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Veuillez entrer le numéro de téléphone';
            if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value!)) {
              return 'Veuillez entrer un numéro valide';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Obx(() => Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonFormField<String>(
              value: controller.selectedRoleId.value.isEmpty ? null : controller.selectedRoleId.value,
              decoration: InputDecoration(
                labelText: 'Rôle',
                labelStyle: TextStyle(color: AppColors.lightTextColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
            ),
          ),
        ));
  }

  Widget _buildSubmitButton() {
    return SpecialButton(
      text: "Créer l'employé",
      onPress: () async {
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
      color: AppColors.primaryColor,
      textColor: Colors.white,
    );
  }
}