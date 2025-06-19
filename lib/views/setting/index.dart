import 'package:demo/controllers/setting/setting_controller.dart';
import 'package:demo/core/class/handeling_data_view.dart';
import 'package:demo/core/class/status_request.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/core/widgets/silver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final SettingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          CustomSilverAppbar(title: 'Paramètres'),
          SliverToBoxAdapter(
            child: GetBuilder<SettingController>(
              builder: (controller) => HandlingDataView(
                statusRequest: controller.statusRequest,
                widget: _buildFormContent()),
            ),
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
            _buildCompanyNameField(),
            const SizedBox(height: 16),
            _buildEmailField(),
            const SizedBox(height: 16),
            _buildPhoneField(),
            const SizedBox(height: 16),
            _buildAddressField(),
            const SizedBox(height: 40),
            _buildSaveButton(),
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
              Icons.settings,
              size: 40,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        Text(
          'Paramètres de l\'entreprise',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Mettez à jour les informations de votre entreprise",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.lightTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCompanyNameField() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          controller: controller.companyNameController,
          decoration: InputDecoration(
            labelText: 'Nom de l\'entreprise',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.business_outlined, color: AppColors.lightTextColor),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer le nom de l\'entreprise' : null,
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
            if (value?.isEmpty ?? true) return "Veuillez entrer l'adresse email";
            if (!value!.contains('@')) return 'Veuillez entrer une adresse email valide';
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
          maxLength: 8,
          decoration: InputDecoration(
            labelText: 'Téléphone',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.phone_outlined, color: AppColors.lightTextColor),
            counterText: '',
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Veuillez entrer le numéro de téléphone';
            if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value!)) {
              return 'Veuillez entrer un numéro valide';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          controller: controller.addressController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Adresse',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.lightTextColor),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Veuillez entrer l\'adresse' : null,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return GetBuilder<SettingController>(
      builder: (controller) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          onPressed: controller.statusRequest == StatusRequest.loading
              ? null
              : () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.updateSetting();
                  }
                },
          child: controller.statusRequest == StatusRequest.loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'ENREGISTRER LES MODIFICATIONS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}