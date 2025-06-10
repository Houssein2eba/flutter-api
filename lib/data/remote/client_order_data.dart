import 'package:demo/core/class/crud.dart';
import 'package:demo/data/app_links.dart';
import 'package:demo/services/stored_service.dart';

class ClientOrderData {
  Crud crud;
  ClientOrderData(this.crud);
  StorageService storage = StorageService();

  getClientOrdersData({required String id}) async {
    var token =  storage.getToken();
    var response = await crud.getData("${AppLinks.clients}/$id", {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    return response.fold((l) => l, (r) => r);
  }
}
