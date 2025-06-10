import 'dart:convert';

import 'package:demo/core/class/status_request.dart';
import 'package:demo/core/functions/handeling_data.dart';
import 'package:demo/data/remote/clients_data.dart';
import 'package:demo/models/client.dart';
import 'package:demo/routes/web.dart';
import 'package:demo/services/stored_service.dart';
import 'package:demo/wigets/tost.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

abstract class AbstractClientsController extends GetxController {
  Future<void> fetchClients({String? search});
  Future<void> searchClient(String search);
  Future<void> deleteClient({required String id});
  Future<void> createClient({required String name, required String phone});
  Future<Client?> getClientById(String id);
  Future<void> updateClient({
    required String id,
    required String name,
    required String phone,
  });
}

class Clientscontroller extends AbstractClientsController {
  final ClientsData _clientsData = ClientsData(Get.find());
  final StorageService _storage = Get.find<StorageService>();

  List<Client> clients = <Client>[];
  StatusRequest statusRequest = StatusRequest.none;
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();

  final String _baseUrl = 'http://192.168.100.13:8000/api';

  @override
  Future<void> fetchClients({String? search}) async {
    try {
      isLoading = true;
      statusRequest = StatusRequest.loading;
      update();

      final response = await _clientsData.getClients(search: search);
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        clients = (response['clients'] as List)
            .map((json) => Client.fromJson(json))
            .toList();

        if (clients.isEmpty) {
          statusRequest = StatusRequest.failure;
        }
      }
    } catch (e) {
      statusRequest = StatusRequest.serverFailure;
      showToast("Error fetching clients: $e", "error");
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  Future<void> searchClient(String search) async {
    if (search.isEmpty) {
      await fetchClients();
    } else {
      await fetchClients(search: search);
    }
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
        showToast("Client deleted successfully", "success");
        update();
      }
    } catch (e) {
      statusRequest = StatusRequest.serverFailure;
      showToast("Error deleting client: $e", "error");
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
      final token = _storage.getToken();

      if (token == null) {
        showToast("Authentication token not found", "error");
        return;
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/clients'),
        headers: _buildHeaders(token),
        body: jsonEncode({'name': name, 'number': phone}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        clients.add(Client.fromJson(data['client']));
        showToast("Client created successfully", "success");
        Get.offNamed('/');
      } else {
        final error = jsonDecode(response.body);
        showToast("Failed to create client: ${error['error']}", "error");
      }
    } catch (e) {
      showToast("Error creating client: $e", "error");
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<Client?> getClientById(String id) async {
    try {
      isLoading = true;
      final token = _storage.getToken();

      if (token == null) {
        showToast("Authentication token not found", "error");
        return null;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/clients/$id'),
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Client.fromJson(data['client']);
      } else {
        showToast("Failed to fetch client: ${response.statusCode}", "error");
        return null;
      }
    } catch (e) {
      showToast("Error fetching client: $e", "error");
      return null;
    } finally {
      isLoading = false;
    }
  }

  @override
  Future<void> updateClient({
    required String id,
    required String name,
    required String phone,
  }) async {
    try {
      isLoading = true;
      final token = _storage.getToken();

      if (token == null) {
        showToast("Authentication token not found", "error");
        return;
      }

      final response = await http.put(
        Uri.parse('$_baseUrl/clients/$id'),
        headers: _buildHeaders(token),
        body: jsonEncode({'id': id, 'name': name, 'number': phone}),
      );

      if (response.statusCode == 200) {
        await fetchClients();
        showToast("Client updated successfully", "success");
        Get.offNamed('/');
      } else {
        final error = jsonDecode(response.body);
        showToast("Failed to update client: ${error['error']}", "error");
      }
    } catch (e) {
      showToast("Error updating client: $e", "error");
    } finally {
      isLoading = false;
    }
  }

  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }
}
