import 'package:demo/core/constant/colors_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/auth_controller.dart';
import 'package:demo/wigets/special_button.dart';

class Login extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RxBool isPasswordHidden = true.obs;

  Login({super.key});
  final Authcontroller authController = Get.find();

  // Custom color palette

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                
                // Animated logo with gradient
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryColor, AppColors.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Welcome text with animation
                Obx(() {
                  if (authController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  return Column(
                    children: [
                      Text(
                        'Système de Gestion de Stock',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Connectez-vous pour continuer',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.lightTextColor,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }),
                
                const SizedBox(height: 40),
                
                // Form with neumorphic design
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email/Phone field
                        TextFormField(
                          controller: loginController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: AppColors.textColor),
                          decoration: InputDecoration(
                            labelText: 'Email ou Téléphone',
                            labelStyle: TextStyle(color: AppColors.lightTextColor),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.lightTextColor,
                            ),
                            filled: true,
                            fillColor: AppColors.backgroundColor.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir votre email ou numéro de téléphone';
                            }
                            if (!value.contains('@')) {
                              if (RegExp(r'^[2-4][0-9]{7}$').hasMatch(value)) {
                                return null;
                              }
                              return 'Veuillez saisir un email ou numéro de téléphone valide';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Password field
                        Obx(
                          () => TextFormField(
                            controller: passwordController,
                            obscureText: isPasswordHidden.value,
                            style: TextStyle(color: AppColors.textColor),
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              labelStyle: TextStyle(color: AppColors.lightTextColor),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: AppColors.lightTextColor,
                              ),
                              filled: true,
                              fillColor: AppColors.backgroundColor.withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordHidden.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.lightTextColor,
                                ),
                                onPressed: () {
                                  isPasswordHidden.value =
                                      !isPasswordHidden.value;
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir votre mot de passe';
                              }
                              return null;
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                          
                        const SizedBox(height: 24),
                        
                        // Login button with gradient
                        SizedBox(
                          width: double.infinity,
                          child: SpecialButton(
                            text: 'Connexion',
                            onPress: () async {
                              if (_formKey.currentState!.validate()) {
                                await authController.login(
                                  loginController.text,
                                  passwordController.text,
                                );
                              }
                            },
                            color: AppColors.primaryColor,
                            textColor: Colors.white,
                            
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        
                        
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}