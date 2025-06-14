import 'package:demo/core/class/handeling_data_view.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/models/client.dart';
import 'package:demo/services/stored_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/client/client_controller.dart';
import 'package:demo/routes/web.dart';

class HomePage extends StatelessWidget {
  final Clientscontroller clientController = Get.find();
  final StorageService storage = Get.find<StorageService>();
  

  
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        "Gestion des Clients",
        style: TextStyle(
          color: AppColors.backgroundColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.backgroundColor),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: AppColors.primaryColor),
          onPressed: clientController.fetchClients,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: clientController.fetchClients,
      color: AppColors.primaryColor,
      child: GetBuilder<Clientscontroller>(
        builder: (controller) => Column(
          children: [
            _buildSearchBar(controller),
            _buildClientList(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(Clientscontroller controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: TextField(
          controller: controller.searchController,
          decoration: InputDecoration(
            labelText: 'Rechercher des Clients',
            labelStyle: TextStyle(color: AppColors.lightTextColor),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: AppColors.lightTextColor),
            suffixIcon: IconButton(
              icon: Icon(Icons.close, color: AppColors.lightTextColor),
              onPressed: () {
                controller.searchController.clear();
                controller.fetchClients();
              },
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          onSubmitted: (query) => _performSearch(controller),
        ),
      ),
    );
  }

  void _performSearch(Clientscontroller controller) {
    final query = controller.searchController.text;
    if (query.isEmpty) {
      controller.fetchClients();
    } else {
      controller.searchClient(query);
    }
  }

  Widget _buildClientList(Clientscontroller controller) {
    return Expanded(
      child: HandlingDataView(
        statusRequest: controller.statusRequest,
        widget: ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: controller.clients.length,
          itemBuilder: (context, index) => _buildClientCard(
            context, 
            controller.clients[index],
          ),
        ),
      ),
    );
  }

  Widget _buildClientCard(BuildContext context, Client client) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToClientDetails(client.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    client.name[0].toUpperCase(),
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      client.phone,
                      style: TextStyle(
                        color: AppColors.lightTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionIcons(client),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcons(Client client) {
    return GetBuilder<Clientscontroller>(
      builder: (controller) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.primaryColor),
              onPressed: () => controller.goToEditClient(client: client),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red[400]),
              onPressed: () => _showDeleteDialog(client.id, client.name),
            ),
          ],
        );
      }
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => Get.toNamed(RouteClass.getCreateClientRoute()),
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _navigateToClientDetails(String clientId) {
    Get.toNamed(
      RouteClass.getShowClientRoute(),
      arguments: {'id': clientId},
    );
  }

  void _showDeleteDialog(String clientId, String clientName) {
    Get.defaultDialog(
      title: 'Supprimer le client',
      titleStyle: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
      content: Text(
        'Êtes-vous sûr de vouloir supprimer $clientName ?',
        style: TextStyle(color: AppColors.lightTextColor),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () async {
          Get.back();
          await clientController.deleteClient(id: clientId);
        },
        child: const Text(
          'SUPPRIMER',
          style: TextStyle(color: Colors.white),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'ANNULER',
          style: TextStyle(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}