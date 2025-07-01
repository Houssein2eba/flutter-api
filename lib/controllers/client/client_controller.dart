import 'dart:convert';


import 'package:demo/wigets/tost.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:demo/core/class/status_request.dart';
import 'package:demo/core/functions/handeling_data.dart';
import 'package:demo/core/functions/success_dialog.dart';
import 'package:demo/data/remote/clients_data.dart';
import 'package:demo/models/client.dart';
import 'package:demo/routes/web.dart';
import 'package:demo/services/stored_service.dart';


abstract class AbstractClientsController extends GetxController {
  Future<void> fetchClients({String? search, bool resetPagination = false});
  Future<void> searchClient(String search);
  Future<void> deleteClient({required String id});
  Future<void> createClient({required String name, required String phone});
  void goToEditClient({required Client client});
}

class Clientscontroller extends AbstractClientsController {
  final ClientsData _clientsData = ClientsData(Get.find());
  final StorageService _storage = Get.find<StorageService>();

  List<Client> clients = <Client>[];
  StatusRequest statusRequest = StatusRequest.none;
  bool isLoading = false;
  int currentPage = 1;
  int lastPage = 1;
  RxBool hasMore = false.obs;
  RxBool isLoadingMore = false.obs;
  int usersCount = 0;
  final TextEditingController searchController = TextEditingController();
  String _currentSearchQuery = '';

  static const String _baseUrl = 'http://192.168.43.180:8000/api';

  @override
  void onInit() {
    fetchClients();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  @override
  Future<void> fetchClients({String? search, bool resetPagination = false}) async {
    try {
      if (resetPagination) {
        currentPage = 1;
        clients.clear();
      }

      if (!isLoadingMore.value) {
        isLoading = true;
        statusRequest = StatusRequest.loading;
        update();
      }

      final response = await _clientsData.getClients(
        search: search,
        page: currentPage,
      );
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        final newClients = (response['clients'] as List)
            .map((json) => Client.fromJson(json))
            .toList();

        if (resetPagination) {
          clients = newClients;
        } else {
          clients.addAll(newClients);
        }

        lastPage = response['meta']['last_page'];
        usersCount = response['users_count'];
        hasMore.value = currentPage < lastPage;
        
        if (clients.isEmpty) {
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      statusRequest = StatusRequest.serverFailure;
      showToast("Error fetching clients: ${e.toString()}", "error");
    } finally {
      isLoading = false;
      isLoadingMore.value = false;
      update();
    }
  }

  Future<void> loadMoreClients() async {
    if (isLoading || !hasMore.value) return;
    isLoadingMore.value = true;
    update();
    currentPage++;
    await fetchClients(search: _currentSearchQuery);
  }

  @override
  Future<void> searchClient(String search) async {
    FocusManager.instance.primaryFocus?.unfocus();
    _currentSearchQuery = search;
    await fetchClients(search: search, resetPagination: true);
  }

  void submitSearch() {
    final query = searchController.text.trim();
    query.isEmpty 
      ? fetchClients(resetPagination: true)
      : searchClient(query);
  }

  void clearSearch() {
    searchController.clear();
    fetchClients(resetPagination: true);
  }

  @override
  Future<void> deleteClient({required String id}) async {
    try {
      statusRequest = StatusRequest.loading;
      update();

      final response = await _clientsData.deleteClient(id: id);
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        clients.removeWhere((client) => client.id == id);
        showSuccessDialog(message: 'Opération réussie!');
        
        if (clients.isEmpty) {
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      statusRequest = StatusRequest.serverFailure;
      showToast("Error deleting client: ${e.toString()}", "error");
    } finally {
      update();
    }
  }

  @override
  Future<void> createClient({
    required String name,
    required String phone,
  }) async {
    try {
      isLoading = true;
      update();

      final token = _storage.getToken();
      if (token == null) {
        showToast("Authentication token not found", "error");
        return;
      }

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/clients'),
        headers: _buildHeaders(token),
        body: jsonEncode({'name': name, 'number': phone}),
      );

      Get.back();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        clients.insert(0, Client.fromJson(data['client']));
        
        showSuccessDialog(
          message: 'Opération réussie!',
          onSuccess: () => Get.until((route) => route.settings.name == RouteClass.home),
        );
      } else {
        final error = jsonDecode(response.body);
        showToast("Échec de la création: ${error['error']}", "error");
      }
    } catch (e) {
      Get.back();
      showToast("Erreur lors de la création: ${e.toString()}", "error");
    } finally {
      isLoading = false;
      update();
    }
  }

  Map<String, String> _buildHeaders(String token) => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  @override
  void goToEditClient({required Client client}) {
    Get.toNamed(
      RouteClass.getEditClientRoute(),
      arguments: {'client': client},
    )?.then((result) {
      if (result == true) fetchClients(resetPagination: true);
    });
  }
}