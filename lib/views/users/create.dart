
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/wigets/special_button.dart';
import 'package:demo/wigets/form_field.dart';
import 'package:demo/controllers/user_controller.dart';

class CreateUser extends StatelessWidget {
  CreateUser({super.key});

  final UserController controller = Get.find();
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(        title: const Text(
          'Créer un Employé',
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      // Compact header
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person_add, size: 32, color: Colors.blue[800]),
                          ),
                          const SizedBox(height: 12),
                          Text(                            'Ajouter un Nouvel Employé',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Remplissez les informations de l\'employé',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Form
                      Expanded(
                        child: Form(
                          key:controller.formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomFormField(
                                controller: controller.nameController,
                                icon: Icons.person,
                                keyboardType: TextInputType.name,                                label: "Nom Complet", 
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez saisir votre nom';
                                  }
                                  return null;
                                },
                                child: Text("Nom Complet"),
                              ),
                              const SizedBox(height: 12),
                              CustomFormField(
                                controller: controller.emailController, 
                                keyboardType: TextInputType.emailAddress, 
                                label: "Email", 
                                icon: Icons.email,                                validator: (value){
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez saisir votre email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Veuillez saisir un email valide';
                                  }
                                  return null;
                                },
                                child: Text("Email"),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller:controller.passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                
                                obscureText: controller.isPasswordVisible.value,
                                validator: (value){                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez saisir votre mot de passe';
                                  }
                                  if (value.length < 6) {
                                    return 'Le mot de passe doit contenir au moins 6 caractères';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(                                  labelText: "Mot de passe",
                                  icon: Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isPasswordVisible.value 
                                          ? Icons.visibility 
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: controller.confirmPasswordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: controller.isConfirmPasswordVisible.value,
                                validator: (value){                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez confirmer votre mot de passe';
                                  }
                                  if (value != controller.passwordController.text) {
                                    return 'Les mots de passe ne correspondent pas';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(                                  labelText: "Confirmer le mot de passe",
                                  icon: Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isConfirmPasswordVisible.value 
                                          ? Icons.visibility 
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      controller.isConfirmPasswordVisible.value = !controller.isConfirmPasswordVisible.value;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              CustomFormField(
                                controller: controller.phoneController,
                                keyboardType: TextInputType.phone,
                                label: "Phone",
                                icon: Icons.phone,                                validator: (value){
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez saisir votre numéro de téléphone';
                                  }
                                  if(!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value)){
                                    return 'Veuillez saisir un numéro de téléphone valide';
                                  }
                                  return null;
                                },
                                child: Text("Phone"),
                              ),
                              const SizedBox(height: 12),
                              Obx(() {
                                
                                
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<String>(                      value: controller.selectedRoleId.value.isEmpty 
                          ? null 
                          : controller.selectedRoleId.value,
                      isExpanded: true,
                      hint: const Text('Sélectionner un rôle'),
                                      items: controller.roles.map((role) {
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
                              const SizedBox(height: 20),
                              SpecialButton(                        text: 'Créer l\'employé',
                        onPress: () async {
                          if (controller.formkey.currentState!.validate()) {
                            if (controller.selectedRoleId.value.isEmpty) {
                              Get.snackbar('Erreur', 'Veuillez sélectionner un rôle');
                                      return;
                                    }
                                    
                                    final success = await controller.createEmployee(

                                    );
                                    
                                    if (success) {
                                      Get.back();
                                    }
                                  }
                                },
                                color: Colors.blue,
                                textColor: Colors.white,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}