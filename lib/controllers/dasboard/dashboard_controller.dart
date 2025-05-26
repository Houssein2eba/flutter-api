import 'dart:convert';


import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';
import 'package:demo/models/dashboard.dart';
import 'package:http/http.dart' as http;

class DashboardController extends GetxController {
  final Rx<Dashboard?> dashboard = Rx<Dashboard?>(null);
  final RxBool isLoading = false.obs;
  
  
  final StorageService storage = Get.find();

  @override
  void onInit()async {
    super.onInit();
    await fetchDashboard();
    
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading(true);
      final token = storage.getToken();
      
      final response = await http.get(
        Uri.parse('http://192.168.100.13:8000/api/dashboard'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        
        final statsData = data ;
        
        dashboard.value = Dashboard.fromJson(statsData);

      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      dashboard.value = null; // Reset on error
    } finally {
      isLoading(false);
    }
  }





}