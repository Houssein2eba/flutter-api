import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomFormField extends StatelessWidget {
  final Widget child;
  final TextEditingController controller ;
  final TextInputType keyboardType;
  final String label;
  
  final String? Function(String?)? validator;
  final IconData icon;
  
   CustomFormField({
    Key? key,
    required this.child,
    
    required this.controller,
    required this.keyboardType,
    required this.label,

    required this.icon,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        
        filled: true,
        fillColor: Colors.white,
        border: Theme.of(context).inputDecorationTheme.border,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
      ),
      validator: validator,
    );
  }
}
