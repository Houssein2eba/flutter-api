import 'package:demo/controllers/user/user_controller.dart';
import 'package:demo/controllers/user/edit_controller.dart';
import 'package:demo/wigets/form_field.dart';
import 'package:demo/wigets/special_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditUser extends StatelessWidget {
  

  EditUser({super.key});

final  EditUserController   controller = Get.put(EditUserController());
final  UserController roleController = Get.put(UserController());

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Edit Employee',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue[800]),
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
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_add, size: 40, color: Colors.blue[800]),
                ),
                const SizedBox(height: 24),
                // Title
                Text(                    'Modifier l\'Employé',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Mettre à jour les détails de l\'employé',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
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
                        icon: Icons.person,
                        keyboardType: TextInputType.name,
                        label: "Full name", 
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        child: Text("Full name"),
                      ),
                      const SizedBox(height: 20),
                      CustomFormField(
                        controller: controller.emailController, 
                        keyboardType: TextInputType.emailAddress, 
                        label: "Email", 
                        icon: Icons.email, 
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        child: Text("Email"),
                      ),
                      const SizedBox(height: 20),
                      
                      CustomFormField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        label: "Phone",
                        icon: Icons.phone,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if(!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value)){
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        child: Text("Phone"),
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        if (roleController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        return InputDecorator(
                          decoration: InputDecoration(
                            
                            
                            contentPadding: const EdgeInsets.only(top: 2),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                              value: controller.selectedRoleId.value.isEmpty 
                                  ? null 
                                  : controller.selectedRoleId.value,
                              isExpanded: true,                                hint: const Text('Sélectionner un Rôle'),
                                items: roleController.roles.map((role) {
                                  return DropdownMenuItem<String>(
                                    value: role!.id.toString(),
                                    child: Text(role.name!),
                                  );
                                }).toList(),
                                validator: (value) => value == null ? 'Veuillez sélectionner un rôle' : null,
                              onChanged: (String? value) {
                                if (value != null) {
                                  controller.selectedRoleId.value = value;
                                }
                              },
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 40),
                      SpecialButton(                      
                          text: 'Confirmer',
                        onPress: ()async {
                          if (controller.formKey.currentState!.validate()) {
                          await  controller.updateUser(id: controller.user!.id!);
                          }
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
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