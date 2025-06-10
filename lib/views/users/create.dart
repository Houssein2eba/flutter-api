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
          'New Employee',
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
              _buildHeader(theme, colors),
              const SizedBox(height: 32),
              _buildFormFields(theme, colors),
              const SizedBox(height: 24),
              _buildSubmitButton(theme, colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colors) {
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
          'Add New Employee',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please fill in the employee details',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(ThemeData theme, ColorScheme colors) {
    return Column(
      children: [
        TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person_outline, color: colors.onSurface.withOpacity(0.6)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Please enter full name' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined, color: colors.onSurface.withOpacity(0.6)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter email';
            if (!value!.contains('@')) return 'Please enter valid email';
            return null;
          },
        ),
        const SizedBox(height: 16),
        Obx(() => TextFormField(
          controller: controller.passwordController,
          obscureText: !controller.isPasswordVisible.value,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock_outline, color: colors.onSurface.withOpacity(0.6)),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: colors.onSurface.withOpacity(0.6),
              ),
              onPressed: () => controller.isPasswordVisible.toggle(),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter password';
            if (value!.length < 6) return 'Password must be at least 6 characters';
            return null;
          },
        )),
        const SizedBox(height: 16),
        Obx(() => TextFormField(
          controller: controller.confirmPasswordController,
          obscureText: !controller.isConfirmPasswordVisible.value,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: Icon(Icons.lock_outline, color: colors.onSurface.withOpacity(0.6)),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isConfirmPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: colors.onSurface.withOpacity(0.6),
              ),
              onPressed: () => controller.isConfirmPasswordVisible.toggle(),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please confirm password';
            if (value != controller.passwordController.text) return 'Passwords do not match';
            return null;
          },
        )),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone_outlined, color: colors.onSurface.withOpacity(0.6)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter phone number';
            if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value!)) {
              return 'Please enter valid phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedRoleId.value.isEmpty 
              ? null 
              : controller.selectedRoleId.value,
          decoration: InputDecoration(
            labelText: 'Role',
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
          validator: (value) => value == null ? 'Please select a role' : null,
          onChanged: (value) {
            if (value != null) {
              controller.selectedRoleId.value = value;
            }
          },
          isExpanded: true,
          hint: const Text('Select a role'),
        )),
      ],
    );
  }

  Widget _buildSubmitButton(ThemeData theme, ColorScheme colors) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (controller.formkey.currentState!.validate()) {
            if (controller.selectedRoleId.value.isEmpty) {
              Get.snackbar(
                'Error',
                'Please select a role',
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
          'Create Employee',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}