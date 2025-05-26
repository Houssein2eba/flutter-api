import 'dart:convert';
import 'dart:io';

import 'package:demo/models/Client.dart';
import 'package:demo/services/stored_service.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:demo/models/order.dart';

import 'package:demo/wigets/tost.dart';

class Clientscontroller extends GetxController {
  var clients = <Client>[].obs;
  List orders = <Order>[].obs;
  RxBool isLoading = false.obs;
  final storage = Get.find<StorageService>();
  @override
  void onInit() {
    fetchClients();
    super.onInit();
  }

  Future<void> fetchClients() async {
    try {
      final token = storage.getToken();
      if (token == null) {
        showToast("Authentication token not found", "error");
        return;
      }
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('http://192.168.100.13:8000/api/clients'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        clients.value = data.map((client) => Client.fromJson(client)).toList();
      } else {
        showToast("faild to load data ${response.statusCode}", "error");
      }
    } catch (e) {
      showToast("Something went wrong: $e", "error");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteClient({required String id}) async {
    isLoading.value = true;
    final response = await http.delete(
      Uri.parse('http://192.168.100.13:8000/api/clients/$id'),
      headers: {
        'Authorization': 'Bearer ${storage.getToken()}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      clients.removeWhere((client) => client.id == id);
      showToast("Client deleted successfully","success");
    } else {
      showToast("deletion faild ${response.statusCode} ", "error");
    }
    isLoading.value = false;
  }

  Future<void> createClient({
    required String name,
    required String phone,
  }) async {
    try {
      isLoading.value = true;
      final token = storage.getToken();

      if (token == null) {
        showToast("Authentication token not found", "error");
        return;
      }

      final response = await http.post(
        Uri.parse('http://192.168.100.13:8000/api/clients'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name, 'number': phone}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showToast("Client created successfully","success");
        final data = jsonDecode(response.body);
        final client = data['client'];
        // Navigate to the home page
        clients.add(Client.fromJson(client));
        Get.toNamed('/');
      } else {
        final error = jsonDecode(response.body);
        showToast("Failed to create client: ${error['error']}", "error");
      }
    } catch (e) {
      showToast("Something went wrong: $e", "error");
    }

    isLoading.value = false;
  }

  Future<Client?> getClientById(String id) async {
    try {
      isLoading.value = true;
      final token = storage.getToken();
      if (token == null) {
        showToast("Authentication token not found", "error");
        return null;
      }
      final response = await http.get(
        Uri.parse('http://192.168.100.13:8000/api/clients/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
       isLoading.value = false;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final client = data['client'];
        return Client.fromJson(client);
      } else {
        showToast("Failed to get client: ${response.statusCode}", "error");
        return null;
      }
      
    } catch (e) {
      showToast("Something went wrong: $e", "error");
      return null;
    }
    
  }

  Future updateClient({
    required String id,
    required String name,
    required String phone,
  }) async {


    try {
      
      isLoading.value = true;
      final token = storage.getToken();
      if (token == null) {
        showToast("Authentication token not found", "error");
        return;
      }
      
      final requestbody = jsonEncode({"id": id, "name": name, "number": phone});
    

      final response = await http.put(
        Uri.parse('http://192.168.100.13:8000/api/clients/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: requestbody,
      );
      if (response.statusCode == 200) {
        showToast("Client updated successfully","success");
  
        
        fetchClients();
        
        Get.toNamed('/');
      }else{
        final errorData = jsonDecode(response.body);
      
        showToast("Failed to update client: ${errorData['error']}", "error");
      }
    } catch (e) {
      showToast("Something went wrong: $e", "error");
    }

    isLoading.value = false;
  }

  Future<void> getOrders({required String id}) async {
    try {
      isLoading.value = true;
      orders.clear();
      final token = storage.getToken();
      if (token == null) {
        showToast("Authentication token not found", "error");
        return;
      }

      final response = await http.get(
        Uri.parse('http://192.168.100.13:8000/api/clients/orders/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        

        List<Order> fetchedOrders = [];

        // Case 1: Response contains 'orders' key
        if (responseData.containsKey('orders')) {
          if (responseData['orders'] is List) {
            fetchedOrders =
                (responseData['orders'] as List)
                    .map<Order>((orderJson) => Order.fromJson(orderJson))
                    .toList();
          }
          // Handle case where 'orders' is a single order Map
          else if (responseData['orders'] is Map) {
            fetchedOrders = [Order.fromJson(responseData['orders'])];
          } else {
            throw FormatException(
              'Expected List or Map for orders, got ${responseData['orders'].runtimeType}',
            );
          }
        }
        // Case 2: Response is directly a List of orders
        else if (responseData is List) {
          fetchedOrders =
              (responseData as List)
                  .map<Order>((orderJson) => Order.fromJson(orderJson))
                  .toList();
        }
        // Unexpected format
        else {
          throw FormatException(
            'Unexpected response format: ${responseData.runtimeType}',
          );
        }

        if (fetchedOrders.isNotEmpty) {
          orders.assignAll(fetchedOrders);
          
        } else {
          Get.snackbar('Info', 'No orders found');
        }
      } else {
        throw HttpException('Failed to load orders');
      }
    } on FormatException catch (e) {
    ;
      showToast(e.message, "error");
    } on HttpException catch (e) {
  
      showToast(e.message, "error");
    } catch (e, stackTrace) {
      
      showToast("Something went wrong: $e", "error");
    }

    isLoading.value = false;
  }

  Future<void> markAsPaid({required String id}) async {
    isLoading.value = true;
    final token = storage.getToken();
    if (token == null) {
      showToast("Authentication token not found", "error");
      return;
    }

    final response = await http.put(
      Uri.parse('http://192.168.100.13:8000/api/clients/orders/mark-paid/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      showToast("Order marked as paid successfully","success");
      final index = orders.indexWhere((order) => order.id == id);

      if (index != -1) {
        // Create a new Order object with updated status
        final updatedOrder = orders[index].copyWith(status: 'paid');

        // Update the list immutably
        orders[index] = updatedOrder;
      }
    } else {
      showToast("Failed to mark order as paid", "error");
    }

    isLoading.value = false;
  }

  Future<void> exportPdf({required String id}) async {
    isLoading.value = true;
    final token = storage.getToken();
    if (token == null) {
      showToast("Authentication token not found", "error");
      return;
    }

    final response = await http.get(
      Uri.parse('http://192.168.100.13:8000/api/clients/orders/export-pdf/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      showToast("PDF exported successfully","success");
    } else {
      showToast("Failed to export PDF", "error");
    }

    isLoading.value = false;
  }
}
