import 'package:demo/controllers/client/client_controller.dart';
import 'package:demo/core/class/status_request.dart';
import 'package:demo/core/functions/handeling_data.dart';
import 'package:demo/core/functions/success_dialog.dart';
import 'package:demo/data/remote/clients_data.dart';
import 'package:demo/models/client.dart';
import 'package:demo/routes/web.dart';
import 'package:demo/wigets/tost.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateClientController extends GetxController {
  Client? client;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  StatusRequest statusRequest = StatusRequest.none;
  ClientsData clientsData = ClientsData(Get.find());

  @override
  void onInit() {
    nameController = TextEditingController();
    phoneController = TextEditingController();
    client = Get.arguments['client'];
    nameController.text = client!.name;
    phoneController.text = client!.phone;
    super.onInit();
  }

  Future<void> updateClient() async {
    statusRequest = StatusRequest.loading;
    update();

    final response = await clientsData.updateClient(
      id: client!.id,
      name: nameController.text,
      phone: phoneController.text,
    );

    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
           
      showSuccessDialog(message: 'Opération réussie!', onSuccess: () {
      Get.until((route) => route.settings.name == RouteClass.home);
        Get.find<Clientscontroller>().fetchClients();
      });
      
} else {
      showToast("Error updating client", "error");
    }
    update();
  }
}
