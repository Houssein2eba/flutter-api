import 'package:demo/services/stored_service.dart';
import 'package:get/get.dart';
import 'package:demo/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:demo/controllers/client_controller.dart';
import 'package:demo/routes/web.dart';
import 'package:demo/wigets/tost.dart';

class Authcontroller extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;

  final storage = Get.find<StorageService>();
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    final response = await http.post(
      Uri.parse('http://192.168.100.13:8000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'credential': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the JSON.
      var data = jsonDecode(response.body);
      

      User user = User.fromJson(data['user']);
      String token = data['token'];

      await storage.saveToken(token);

      await storage.saveUser(user);

      final clientController = Get.put(Clientscontroller());
      await clientController.fetchClients();
      Get.offAllNamed(RouteClass.getDashBoardRoute()); // Navigate to the home page
    } else {
    
      
      showToast("invalid email or password", "error");
    }
    isLoading.value = false;
  }

  Future<void> logout() async {
    final token = storage.getToken();

    final response = await http.post(
      Uri.parse('http://192.168.100.13:8000/api/logout'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the JSON.
      await storage.clearToken();
      Get.offAllNamed(RouteClass.getLoginRoute()); // Navigate to the login page
    } else {
    

      // If the server did not return a 200 OK response, throw an exception.
      showToast("faild to logout", "error");
    }
  }
}
