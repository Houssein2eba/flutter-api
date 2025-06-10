import 'package:demo/core/class/handeling_data_view.dart';
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
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text("Gestion des Clients"),
      backgroundColor: Colors.blue,
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: clientController.fetchClients,
        child: GetBuilder<Clientscontroller>(
          builder: (controller) => Column(
            children: [
              _buildSearchBar(controller),
              _buildClientList(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(Clientscontroller controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.searchController,
              decoration: const InputDecoration(
                labelText: 'Rechercher des Clients',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (query) => _performSearch(controller),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _performSearch(controller),
          ),
        ],
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
          itemCount: controller.clients.length,
          itemBuilder: (context, index) => _buildClientCard(context, controller.clients[index]),
        ),
      ),
    );
  }

  Widget _buildClientCard(BuildContext context, Client client) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(client.name[0].toUpperCase()),
        ),
        title: Text(
          client.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(client.phone),
        trailing: _buildActionIcons(client),
        onTap: () => _navigateToClientDetails(client.id),
      ),
    );
  }

  Widget _buildActionIcons(Client client) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _navigateToEditClient(client),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _showDeleteDialog(client.id, client.name),
        ),
      ],
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => Get.toNamed(RouteClass.getCreateClientRoute()),
      tooltip: 'Ajouter un nouveau client',
      child: const Icon(Icons.add),
    );
  }

  void _navigateToClientDetails(String clientId) {
    Get.toNamed(
      RouteClass.getShowClientRoute(),
      arguments: {'id': clientId},
    );
  }

  void _navigateToEditClient(Client client) {
    Get.toNamed(
      RouteClass.getEditClientRoute(),
      arguments: {
        'id': client.id,
        'name': client.name,
        'phone': client.phone,
      },
    );
  }

  void _showDeleteDialog(String clientId, String clientName) {
    Get.defaultDialog(
      title: 'Supprimer le client',
      content: Text('Êtes-vous sûr de vouloir supprimer $clientName ?'),
      confirm: TextButton(
        onPressed: () async {
          Get.back();
          await clientController.deleteClient(id: clientId);
        },
        child: const Text(
          'SUPPRIMER',
          style: TextStyle(color: Colors.red),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('ANNULER'),
      ),
    );
  }
}