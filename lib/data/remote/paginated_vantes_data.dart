import 'package:demo/core/class/crud.dart';
import 'package:demo/data/app_links.dart';
import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';

class PaginatedVentesData {
  Crud crud;
  PaginatedVentesData(this.crud);
  StorageService storage = Get.find();

  getPaginatedVentes({int page = 1}) async {
    String? token = storage.getToken();
    String url = '${AppLinks.paginatedVentes}?page=$page';
    
    var response = await crud.getData(url, {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }
}