import 'package:demo/core/class/crud.dart';
import 'package:demo/data/app_links.dart';
import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';


class SettingData{

  Crud crud;
  SettingData(this.crud);
  StorageService storageService = Get.find();


  getSetting() async {
    String? token =  storageService.getToken();
    var response = await crud.getData(AppLinks.settings, {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  updateSetting(Map<String, dynamic> data) async {
    String? token =  storageService.getToken();
    var response = await crud.putData(AppLinks.settings, 
    {
      'company_name': data['company_name'],
      'email': data['email'],
      'phone': data['phone'],
      'address': data['address'],
    }
    ,{
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

}