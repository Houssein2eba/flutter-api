

import 'package:flutter/material.dart';
import 'package:get/get.dart';

handleValidationErrors(var response){
  if (response["errors"] != null) {
  Map<String, dynamic> errors = response["errors"];

  // Affiche chaque erreur avec Get.snackbar
  errors.forEach((field, messages) {
    for (var msg in messages) {
      Get.snackbar(
        'Erreur',
        msg.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  });
} else {
  Get.snackbar(
    'Erreur',
    response["message"] ?? "Erreur inconnue",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.withOpacity(0.8),
    colorText: Colors.white,
  );
}

}