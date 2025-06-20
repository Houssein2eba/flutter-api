import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSuccessDialog({required String message, VoidCallback? onSuccess}) {
  Get.defaultDialog(
    title: 'Succès', 
    middleText: 'Opération réussie!',
    titleStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.green,
    ),
    middleTextStyle: TextStyle(
      fontSize: 16,
    ),
    backgroundColor: Colors.white,
    radius: 10,
    content: Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 48,
          ),
        ),
        SizedBox(height: 16),
        Text(
          message, // "Success" in French
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 8),
      ],
    ),
    confirm: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        if (onSuccess != null) {
        // Get.back();
          onSuccess();
        }else{
        Get.back();

        }
      },
      child: Text(
        'OK',
        style: TextStyle(color: Colors.white),
      ),
    ),
    barrierDismissible: true,
  );
}

