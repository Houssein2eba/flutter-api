import 'package:demo/controllers/client/client_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/wigets/special_button.dart';

class CreateClient extends StatelessWidget {
  CreateClient({super.key});
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Clientscontroller clientsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            'Create Client',
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
                  const SizedBox(height: 10),
                  const SizedBox.shrink(),
                  const SizedBox(height: 24),
                  // Title
                  Text(                    'Ajouter un Nouveau Client',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Remplissez les détails du client',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(                            labelText: 'Nom Complet',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.grey[600],
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: Theme.of(context).inputDecorationTheme.border,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.blue[800]!,
                                width: 2,
                              ),
                            ),
                          ),                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir le nom du client';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(                            labelText: 'Numéro de Téléphone',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: Colors.grey[600],
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: Theme.of(context).inputDecorationTheme.border,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: Theme.of(context).inputDecorationTheme.border!.borderSide,
                            ),
                            hintText: 'e.g. 21234567',
                          ),                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez saisir le numéro de téléphone';
                            }  
                            if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value)) {
                              return 'Veuillez saisir un numéro de téléphone valide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),                        // Create button
                        SpecialButton(
                          text: 'Créer Client',
                          onPress: () {
                            // if (_formKey.currentState!.validate()) {
                            //   clientsController.createClient(
                            //     name: nameController.text,
                            //     phone: phoneController.text,
                            //   );
                            // }
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
      ),
    );
  }
}