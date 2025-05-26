
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/wigets/special_button.dart';
import 'package:demo/wigets/form_field.dart';
import 'package:demo/controllers/user_controller.dart';

class CreateUser extends StatelessWidget {
  CreateUser({super.key});
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Create Employee',
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
                          Text(
                            'Add New Employee',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Fill in the employee details',
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
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomFormField(
                                controller: nameController,
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
                              const SizedBox(height: 12),
                              CustomFormField(
                                controller: emailController, 
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
                              const SizedBox(height: 12),
                              CustomFormField(
                                controller: passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                label: "Password",
                                icon: Icons.lock,
                                obscureText: true,
                                validator: (value){
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                child: Text("Password"),
                              ),
                              const SizedBox(height: 12),
                              CustomFormField(
                                controller: confirmPasswordController,
                                keyboardType: TextInputType.visiblePassword,
                                label: "Confirm Password",
                                icon: Icons.lock,
                                obscureText: true,
                                validator: (value){
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                child: Text("Confirm Password"),
                              ),
                              const SizedBox(height: 12),
                              CustomFormField(
                                controller: phoneController,
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
                              const SizedBox(height: 12),
                              Obx(() {
                                if (userController.isLoading.value) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<String>(
                                      value: userController.selectedRoleId.value.isEmpty 
                                          ? null 
                                          : userController.selectedRoleId.value,
                                      isExpanded: true,
                                      hint: const Text('Select Role'),
                                      items: userController.roles.map((role) {
                                        return DropdownMenuItem<String>(
                                          value: role!.id.toString(),
                                          child: Text(role.name!),
                                        );
                                      }).toList(),
                                      validator: (value) => value == null ? 'Please select a role' : null,
                                      onChanged: (String? value) {
                                        if (value != null) {
                                          userController.selectedRoleId.value = value;
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(height: 20),
                              SpecialButton(
                                text: 'Create Employee',
                                onPress: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (userController.selectedRoleId.value.isEmpty) {
                                      Get.snackbar('Error', 'Please select a role');
                                      return;
                                    }
                                    
                                    final success = await userController.createEmployee(
                                      name: nameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text,
                                      password: passwordController.text,
                                      roleId: userController.selectedRoleId.value,
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