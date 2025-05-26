

import 'dart:convert';
import 'dart:io';

import 'package:demo/functions/handle_validation.dart';
import 'package:demo/models/order.dart';
import 'package:demo/services/stored_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SingleOrderController extends GetxController{

  final RxBool isLoading= false.obs;
  final StorageService storage = Get.find();
  final RxList<Order> orderDetails = <Order>[].obs;
  late final id;

  @override
  void onInit() async {
    super.onInit();
    id = Get.arguments['id'];
    
     await  fetchOrderDetails();
    
    print('Order ID: $id');
  }

  Future<void> fetchOrderDetails() async {
    try {
      isLoading(true);
      final token = storage.getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse('http://192.168.100.13:8000/api/clients/orders/$id'),
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String,dynamic> data = json.decode(response.body);
        for(var item in data['orders']) {
          orderDetails.add(Order.fromJson(item));
        }
        print('Order Details: ${orderDetails.length}');
      }else {
        Get.snackbar(
          'Error',
          'Failed to load order details: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading(false);
    }
  }
  Future<void> exportPdf({required String id}) async {
  try {
    // Check and request permissions
    final permissionStatus = await Permission.storage.request();
    if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      Get.snackbar(
        "Permission Required",
        "Storage access is required to download PDF",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Show loading indicator
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    // API URL
    final url = 'http://192.168.100.13:8000/api/clients/orders/export-pdf/$id';

    // Make the request
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${storage.getToken()}',
        'Accept': 'application/json',
      },
    );

    // Close loading dialog
    Get.back();

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      
      if (responseData['success'] == true) {
        // Get the downloads directory
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/${responseData['filename']}';
        final file = File(filePath);
        print("=================$filePath");
        
        // Decode and save the PDF
        final pdfBytes = base64.decode(responseData['pdf']);
        await file.writeAsBytes(pdfBytes);
        
        // Open the PDF
        final result = await OpenFile.open(file.path);
        
        if (result.type != ResultType.done) {
          Get.snackbar(
            "Error",
            "Could not open PDF file",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          responseData['message'] ?? "Failed to generate PDF",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Failed to generate PDF (Status: ${response.statusCode})",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    Get.back(); 
    Get.snackbar(
      "Error",
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
    );
    debugPrint("PDF Export Error: $e");
  }
}


    Future<void> markAsPaid({required String id}) async {
    isLoading.value = true;
    final token = storage.getToken();
  

    final response = await http.put(
      Uri.parse('http://192.168.100.13:8000/api/clients/orders/mark-paid/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      UsefulFunctions.showToast("Order marked as paid successfully","success");
      final index = orderDetails.indexWhere((order) => order.id == id);

      if (index != -1) {
        // Create a new Order object with updated status
        final updatedOrder = orderDetails[index].copyWith(status: 'paid');

        // Update the list immutably
        orderDetails[index] = updatedOrder;
      }
    } else {
      UsefulFunctions.showToast("Failed to mark order as paid", "error");
    }

    isLoading.value = false;
  }

  Map<String, String> _buildHeaders(String token) {
    
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}