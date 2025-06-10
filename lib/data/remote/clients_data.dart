import 'package:demo/core/class/crud.dart';
import 'package:demo/data/app_links.dart';
import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';

class ClientsData {
  Crud crud;
  ClientsData(this.crud);
  StorageService storage = Get.find();

  getClients({String? search}) async {
    String? token = storage.getToken();
    String url = AppLinks.clients;
    if (search != null) {
      url = "${AppLinks.clients}?search=$search";
    }
    var response = await crud.getData(url, {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    return response.fold((l) => l, (r) => r);
  }

  deleteClient({required String id}) async {
    String? token = storage.getToken();
    var response = await crud.deleteData("${AppLinks.clients}/$id", {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    return response.fold((l) => l, (r) => r);
  }
}
