import 'dart:convert';
import 'dart:io';

import 'package:demo/core/class/status_request.dart';
import 'package:demo/core/functions/handeling_data.dart';
import 'package:demo/data/remote/vente_data.dart';
import 'package:demo/models/order.dart';
import 'package:demo/services/stored_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VentesController extends GetxController {
  List<Order> orders = [];
  StatusRequest statusRequest = StatusRequest.none;
  VenteData venteData = VenteData(Get.find());
  StorageService storage = Get.find();

  @override
  void onInit() {
    print("onInit ${storage.getToken()}");
    getOrders();
    super.onInit();
  }

  Future<void> getOrders() async {
    statusRequest = StatusRequest.loading;
    update();
    try {
      var response = await venteData.getVentes();
      print(response);
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        if (response['orders'] != null) {
          for (var order in response['orders']) {
            orders.add(Order.fromJson(order));
          }
        } else {
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      statusRequest = StatusRequest.failure;
      update();
    }
    update();
  }

  Future<void> markAsPaid({required String id}) async {
    statusRequest = StatusRequest.loading;
    update();

    final token = storage.getToken();

    final response = await http.put(
      Uri.parse('http://192.168.100.13:8000/api/clients/orders/mark-paid/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    statusRequest = StatusRequest.success;
    update();
    if (response.statusCode == 200) {
      final index = orders.indexWhere((order) => order.id == id);

      if (index != -1) {
        // Create a new Order object with updated status
        final updatedOrder = orders[index].copyWith(status: 'paid');

        // Update the list immutably
        orders[index] = updatedOrder;
      }
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
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
      final url =
          'http://192.168.100.13:8000/api/clients/orders/export-pdf/$id';

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
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
      debugPrint("PDF Export Error: $e");
    }
  }
}
