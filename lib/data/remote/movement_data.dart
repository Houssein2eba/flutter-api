import 'package:demo/core/class/crud.dart';
import 'package:demo/data/app_links.dart';
import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';

class MovementData {
  Crud crud;
  MovementData(this.crud);
  StorageService storage = Get.find();

  getMovementsData({required String id}) async {
    String? token = storage.getToken();
    var response=await crud.getData("${AppLinks.movements}/$id", {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }
    );
    return response.fold((l) => l, (r) => r);
  }
}
