

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/user/user_controller.dart';

class CreateUser extends StatelessWidget {
  CreateUser({super.key});
  final UserController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(
          'Nouvel Employé',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: colors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.onPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _entete(theme, colors),
              const SizedBox(height: 32),
              _champsFormulaire(theme, colors),
              const SizedBox(height: 24),
              _boutonValider(theme, colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _entete(ThemeData theme, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_add_alt_1,
            size: 32,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Ajouter un nouvel employé',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Veuillez remplir les informations de l’employé',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _champsFormulaire(ThemeData theme, ColorScheme colors) {
    return Column(
      children: [
        TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: 'Nom complet',
            prefixIcon: Icon(Icons.person_outline, color: colors.onSurface.withOpacity(0.6)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
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
            prefixIcon: Icon(Icons.email_outlined, color: colors.onSurface.withOpacity(0.6)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Veuillez entrer l’adresse e-mail';
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
                prefixIcon: Icon(Icons.lock_outline, color: colors.onSurface.withOpacity(0.6)),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                    color: colors.onSurface.withOpacity(0.6),
                  ),
                  onPressed: () => controller.isPasswordVisible.toggle(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
                prefixIcon: Icon(Icons.lock_outline, color: colors.onSurface.withOpacity(0.6)),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                    color: colors.onSurface.withOpacity(0.6),
                  ),
                  onPressed: () => controller.isConfirmPasswordVisible.toggle(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
            prefixIcon: Icon(Icons.phone_outlined, color: colors.onSurface.withOpacity(0.6)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Veuillez entrer le numéro de téléphone';
            if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value!)) {
              return 'Veuillez entrer un numéro valide ';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedRoleId.value.isEmpty ? null : controller.selectedRoleId.value,
              decoration: InputDecoration(
                labelText: 'Rôle',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
              hint: const Text('Sélectionnez un rôle'),
            )),
      ],
    );
  }

  Widget _boutonValider(ThemeData theme, ColorScheme colors) {
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
                backgroundColor: colors.error,
                colorText: colors.onError,
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
          backgroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Créer l’employé',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
