import 'package:demo/services/stored_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/auth_controller.dart';
import 'package:demo/controllers/client_controller.dart';
import 'package:demo/controllers/notification_controller.dart';
import 'package:demo/wigets/drawer.dart';
import 'package:demo/routes/web.dart';

class HomePage extends StatelessWidget {
  final Clientscontroller clientController = Get.find();

  final NotificationController notificationController = Get.put(
    NotificationController(),
  );
  final storage = Get.find<StorageService>();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        userName: storage.getUser()!.name,
        userEmail: storage.getUser()!.email,
      ),
      appBar: AppBar(
        title: const Text("Client Management"),
        backgroundColor: Colors.blue.shade800,
        actions: [_buildNotificationIcon()],
      ),
    
      body: SafeArea(child: _buildBody()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(RouteClass.getCreateClientRoute()),
        tooltip: 'Add New Client',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Obx(() {
      final count = notificationController.unreadCount.value;
      return IconButton(
        icon: Stack(
          children: [
            const Icon(Icons.notifications),
            if (count > 0)
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        onPressed: () => Get.toNamed(RouteClass.getNotificationsRoute()),
        tooltip: 'Notifications',
      );
    });
  }


  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: clientController.fetchClients,
      child: Obx(() {
        if (clientController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (clientController.clients.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people_outline, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No Clients Found',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your first client using the + button',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: clientController.clients.length,
          itemBuilder: (context, index) {
            final client = clientController.clients[index];
            return Card(
              
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                
                leading: CircleAvatar(
                  
                  backgroundColor: Colors.blue.shade100,
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
                      onPressed:
                          () => _showDeleteDialog(client.id, client.name),
                    ),
                  ],
                ),
                onTap: ()async {
                  await clientController.getOrders(id: client.id);
                  Get.toNamed(RouteClass.getShowClientRoute());
                },
              ),
            );
          },
        );
      }),
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
