import 'package:demo/controllers/client/client_controller.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/core/widgets/silver_appbar.dart';
import 'package:demo/wigets/special_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateClient extends StatelessWidget {
  CreateClient({super.key});
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Clientscontroller clientsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          CustomSilverAppbar(title: 'Nouveau Client'),
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
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with icon
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
            
            // Title
            Text(
              'Ajouter un Nouveau Client',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Remplissez les informations du client',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.lightTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Name Field
            _buildInputCard(
              controller: nameController,
              label: 'Nom Complet',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez saisir le nom du client';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            
            // Phone Field
            _buildInputCard(
              controller: phoneController,
              label: 'Numéro de Téléphone',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              maxLength: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez saisir le numéro de téléphone';
                }  
                if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value)) {
                  return 'Numéro de téléphone invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
            
            // Create Button
            SpecialButton(
              text: 'Créer Client',
              onPress: () {
                if (_formKey.currentState!.validate()) {
                  clientsController.createClient(
                    name: nameController.text,
                    phone: phoneController.text,
                  );
                }
              },
              color: AppColors.primaryColor,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            border: InputBorder.none,
            prefixIcon: Icon(icon, color: AppColors.lightTextColor),
            counterText: '',
          ),
        ),
      ),
    );
  }
}