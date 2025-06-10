import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UsefulFunctions {
  static bool isEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  static handleValidationErrors(http.Response response) {
    final data = json.decode(response.body);
    final errors = data['errors'] as Map<String, dynamic>;
    final errorMessage = errors.entries
        .map((e) => '${e.key}: ${e.value.join(', ')}')
        .join('\n');
    showToast(errorMessage, 'error');
    
  }

  static String  formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year} ${parsedDate.hour}:${parsedDate.minute}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  static showToast(String message, String type) {
    Get.snackbar(
      type,
      message,
      backgroundColor: type == 'success' ? Colors.green : Colors.red,
      colorText: Colors.white,
      icon: Icon(Icons.error, color: Colors.white),
    );
  }
}
