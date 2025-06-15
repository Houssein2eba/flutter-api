import 'package:demo/core/class/crud.dart';
import 'package:demo/data/app_links.dart';
import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';

class VenteData {
  Crud crud;
  VenteData(this.crud);

  StorageService storage = Get.find();
  String? token;

  getVentes()async{
    token = storage.getToken();
    var response=await crud.getData(AppLinks.ventes, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }
    );
    return response.fold((l) => l, (r) => r);
  }
}
