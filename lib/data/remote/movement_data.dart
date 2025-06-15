import 'package:demo/core/class/crud.dart';
import 'package:demo/data/app_links.dart';
import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';

class MovementData {
  Crud crud;
  MovementData(this.crud);
  StorageService storage = Get.find();

  getMovementsData({required String id, String? type}) async {
    String? token = storage.getToken();

    String url = "${AppLinks.movements}/$id";
    if (type != null) {
      url += "?type=$type";
    }

    var response = await crud.getData(url, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }
}
