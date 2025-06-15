
import 'package:demo/core/constant/colors_class.dart';
import 'package:flutter/material.dart';


class CustomFloatingAction extends StatelessWidget {
  final void Function()? onPressed;
  
  const CustomFloatingAction({super.key,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Nouveau',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

  }
}