import 'package:demo/core/class/handeling_data_view.dart';
import 'package:demo/services/stored_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/client/client_controller.dart';
import 'package:demo/routes/web.dart';

class HomePage extends StatelessWidget {
  final Clientscontroller clientController = Get.find();
  final storage = Get.find<StorageService>();
  
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Client Management"),
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(child: _buildBody()),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(RouteClass.getCreateClientRoute()),
          tooltip: 'Add New Client',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: clientController.fetchClients,
      child: GetBuilder<Clientscontroller>(
        builder: (controller) {
          return Column(
            children: [
              //search bar
              Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller.search,
                    decoration: InputDecoration(
                      labelText: 'Search Clients',
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      
                        controller.searchClient( value);
                      
                    },
                  ),
                ),
              ),
                Expanded(
                  child: HandlingDataView(
                    statusRequest: controller.statusRequest,
                    widget: ListView.builder(
                      itemCount: controller.clients.length,
                      itemBuilder: (context, index) {
                        final client = controller.clients[index];
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Map<String, dynamic> singleclient = {
                                      'id': client.id,
                                      'name': client.name,
                                      'phone': client.phone,
                                    };
                                    Get.toNamed(
                                      RouteClass.getEditClientRoute(),
                                      arguments: singleclient,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _showDeleteDialog(client.id, client.name),
                                ),
                              ],
                            ),
                            onTap: () {
                              Get.toNamed(RouteClass.getShowClientRoute(),arguments: {'id':client.id.toString()});
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        }
      ),
    );
  }

  void _showDeleteDialog(String clientId, String clientName) {
    Get.defaultDialog(
      title: 'Delete Client',
      content: Text('Are you sure you want to delete $clientName?'),
      confirm: TextButton(
        onPressed: () async {
          Get.back();
          await clientController.deleteClient(id: clientId);
        },
        child: const Text('DELETE', style: TextStyle(color: Colors.red)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('CANCEL'),
      ),
    );
  }
}