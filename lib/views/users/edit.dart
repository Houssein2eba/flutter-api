import 'package:demo/controllers/user/user_controller.dart';
import 'package:demo/controllers/user/edit_controller.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/wigets/form_field.dart';
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
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Modifier Employé',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Header with icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_add,
                    size: 40,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                Text(
                  'Modifier l\'Employé',
                  style: TextStyle(
                    fontSize: 24,
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
                const SizedBox(height: 40),
                // Form
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      CustomFormField(
                        controller: controller.nameController,
                        icon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                        label: "Nom complet",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le nom complet';
                          }
                          return null;
                        },
                        child: Text("Nom complet"),
                      ),
                      const SizedBox(height: 20),
                      CustomFormField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        label: "Email",
                        icon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          }
                          if (!value.contains('@')) {
                            return 'Veuillez entrer un email valide';
                          }
                          return null;
                        },
                        child: Text("Email"),
                      ),
                      const SizedBox(height: 20),
                      CustomFormField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        label: "Téléphone",
                        icon: Icons.phone_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre numéro de téléphone';
                          }
                          if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value)) {
                            return 'Veuillez entrer un numéro valide';
                          }
                          return null;
                        },
                        child: Text("Téléphone"),
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        if (roleController.isLoading.value) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          );
                        }

                        return InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 2),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                width: 1.5,
                              ),
                            ),
                          ),
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
                              icon: Icon(Icons.arrow_drop_down, color: AppColors.lightTextColor),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: SpecialButton(
                          text: 'Confirmer',
                          onPress: () async {
                            if (controller.formKey.currentState!.validate()) {
                              await controller.updateUser(id: controller.user!.id!);
                            }
                          },
                          color: AppColors.primaryColor,
                          textColor: Colors.white,
                          
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}