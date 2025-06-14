import 'package:demo/core/class/crud.dart';
import 'package:demo/data/app_links.dart';
import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';

class RolesData {
  Crud crud;
  RolesData(this.crud);

  StorageService storage = Get.find<StorageService>();

  getRoles() async {
    String? token = storage.getToken();
    var response = await crud.getData(AppLinks.roles, {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });

    return response.fold((l) => l, (r) => r);
  }

  getPermisssions() async {
    String? token = storage.getToken();
    var response = await crud.getData(AppLinks.permissions, {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });
    

    return response.fold((l) => l, (r) => r);
  }

  createRole({required String role,required List<String> perissions}) async {
    String? token = storage.getToken();
    var response = await crud.postJsonData(AppLinks.permissions, 
    {
      'role':role,
      'permissions':perissions
    }
    , {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  deleteRole(String id) async {
    String? token = storage.getToken();
    print(id);
    var response = await crud.deleteData("${AppLinks.roles}/$id", {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });

    return response.fold((l) => l, (r) => r);
  }
}
