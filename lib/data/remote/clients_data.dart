import 'package:demo/core/class/crud.dart';
import 'package:demo/data/app_links.dart';
import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';

class ClientsData {
  Crud crud;
  ClientsData(this.crud);
  StorageService storage = Get.find();

  getClients({String? search,int page = 1}) async {
    String? token = storage.getToken();
    String url = "${AppLinks.clients}?page=$page";
    if (search != null) {
      url = "${AppLinks.clients}?search=$search&page=$page";
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



  updateClient({
    required String id,
    required String name,
    required String phone,
  }) async {
    String? token = storage.getToken();
    var response = await crud.putData(
      "${AppLinks.clients}/$id",
      {'name': name, 'number': phone},
      {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    return response.fold((l) => l, (r) => r);
  }
}
