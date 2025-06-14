import 'package:demo/core/constant/colors_class.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/client/update_client_controller.dart';

class EditClientScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  EditClientScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateClientController());

    return Scaffold(
      backgroundColor:  AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Modifier Client',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildNameField(controller),
              const SizedBox(height: 16),
              _buildPhoneField(controller),
              const SizedBox(height: 32),
              _buildUpdateButton(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
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
        const SizedBox(height: 16),
        Text(
          'Modifier les détails du client',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Mettre à jour les informations du client',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.lightTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(UpdateClientController controller) {
    return TextFormField(
      controller: controller.nameController,
      decoration: InputDecoration(
        labelText: 'Nom Complet',
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
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
      ),
      style: TextStyle(color: AppColors.textColor),
      validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer un nom' : null,
    );
  }

  Widget _buildPhoneField(UpdateClientController controller) {
    return TextFormField(
      controller: controller.phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Numéro de Téléphone',
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
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        hintText: 'ex: 21234567',
        hintStyle: TextStyle(color: AppColors.lightTextColor.withOpacity(0.5)),
      ),
      style: TextStyle(color: AppColors.textColor),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Veuillez entrer un numéro de téléphone';
        if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value!)) {
          return 'Numéro de téléphone invalide';
        }
        return null;
      },
    );
  }

  Widget _buildUpdateButton(UpdateClientController controller) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await controller.updateClient();
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
        'Mettre à jour',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}