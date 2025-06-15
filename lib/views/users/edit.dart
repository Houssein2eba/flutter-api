import 'package:demo/controllers/user/user_controller.dart';
import 'package:demo/controllers/user/edit_controller.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/core/widgets/loadin_indicator.dart';
import 'package:demo/core/widgets/silver_appbar.dart';
import 'package:demo/wigets/special_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditUser extends StatelessWidget {
  EditUser({super.key});

  final EditUserController controller = Get.put(EditUserController());
  final UserController roleController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          CustomSilverAppbar(title: 'Modifier Employé'),
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
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildNameField(),
            const SizedBox(height: 16),
            _buildEmailField(),
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
              Icons.person_outline,
              size: 40,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        Text(
          'Modifier l\'Employé',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Mettre à jour les détails de l\'employé',
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer le nom complet';
            }
            return null;
          },
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
            labelText: 'Email',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.email_outlined, color: AppColors.lightTextColor),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre email';
            }
            if (!value.contains('@')) {
              return 'Veuillez entrer un email valide';
            }
            return null;
          },
        ),
      ),
    );
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
          decoration: InputDecoration(
            labelText: 'Téléphone',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.phone_outlined, color: AppColors.lightTextColor),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre numéro de téléphone';
            }
            if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value)) {
              return 'Veuillez entrer un numéro valide';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Obx(() {
      if (roleController.isLoading.value) {
        return const LoadinIndicator();
      }

      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              value: controller.selectedRoleId.value.isEmpty
                  ? null
                  : controller.selectedRoleId.value,
              isExpanded: true,
              hint: Text(
                'Sélectionner un Rôle',
                style: TextStyle(color: AppColors.lightTextColor),
              ),
              items: roleController.roles.map((role) {
                return DropdownMenuItem<String>(
                  value: role!.id.toString(),
                  child: Text(
                    role.name!,
                    style: TextStyle(color: AppColors.textColor),
                  ),
                );
              }).toList(),
              validator: (value) =>
                  value == null ? 'Veuillez sélectionner un rôle' : null,
              onChanged: (String? value) {
                if (value != null) {
                  controller.selectedRoleId.value = value;
                }
              },
              dropdownColor: Colors.white,
              icon: Icon(
                Icons.arrow_drop_down,
                color: AppColors.lightTextColor,
              ),
              decoration: InputDecoration(
                labelText: 'Rôle',
                labelStyle: TextStyle(color: AppColors.lightTextColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSubmitButton() {
    return SpecialButton(
      text: 'Confirmer',
      onPress: () async {
        if (controller.formKey.currentState!.validate()) {
          await controller.updateUser(
            id: controller.user!.id!,
          );
        }
      },
      color: AppColors.primaryColor,
      textColor: Colors.white,
    );
  }
}