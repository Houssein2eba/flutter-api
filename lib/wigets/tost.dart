import 'package:flutter/material.dart';

import 'package:get/get.dart';


  showToast(String message,String type) {
    Get.snackbar(
      type,
      message,
      backgroundColor: type == 'success' ? Colors.green : Colors.red,
      colorText: Colors.white,
      icon: Icon(Icons.error, color: Colors.white),
    );
  }

