import 'package:demo/controllers/client/update_client_controller.dart';
import 'package:demo/core/class/handeling_data_view.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/core/widgets/silver_appbar.dart';
import 'package:demo/wigets/special_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditClientScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  EditClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UpdateClientController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          CustomSilverAppbar(title: 'Modifier Client'),
          SliverToBoxAdapter(child: _buildFormContent(controller)),
        ],
      ),
    );
  }

  Widget _buildFormContent(UpdateClientController controller) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GetBuilder<UpdateClientController>(
        builder: (context) {
          return Form(
            key: _formKey,
            child: HandlingDataView(
              statusRequest: controller.statusRequest,
              widget: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildNameField(controller),
                  const SizedBox(height: 20),
                  _buildPhoneField(controller),
                  const SizedBox(height: 40),
                  _buildUpdateButton(controller),
                ],
              ),
            ),
          );
        }
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
              Icons.person_outline,
              size: 40,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        Text(
          'Modifier les détails du client',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Mettre à jour les informations du client',
          style: TextStyle(fontSize: 14, color: AppColors.lightTextColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNameField(UpdateClientController controller) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          controller: controller.nameController,
          decoration: InputDecoration(
            labelText: 'Nom Complet',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.person_outline,
              color: AppColors.lightTextColor,
            ),
          ),
          style: TextStyle(color: AppColors.textColor),
          validator:
              (value) =>
                  value?.isEmpty ?? true ? 'Veuillez entrer un nom' : null,
        ),
      ),
    );
  }

  Widget _buildPhoneField(UpdateClientController controller) {
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
            labelText: 'Numéro de Téléphone',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: AppColors.lightTextColor,
            ),
            counterText: '',
            hintText: 'ex: 21234567',
            hintStyle: TextStyle(
              color: AppColors.lightTextColor.withOpacity(0.5),
            ),
          ),
          style: TextStyle(color: AppColors.textColor),
          validator: (value) {
            if (value?.isEmpty ?? true)
              return 'Veuillez entrer un numéro de téléphone';
            if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value!)) {
              return 'Numéro de téléphone invalide';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildUpdateButton(UpdateClientController controller) {
    return SpecialButton(
      text: 'Mettre à jour',
      onPress: () async {
        if (_formKey.currentState!.validate()) {
          await controller.updateClient();
        }
      },
      color: AppColors.primaryColor,
      textColor: Colors.white,
    );
  }
}
