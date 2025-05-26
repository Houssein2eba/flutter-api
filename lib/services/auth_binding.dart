
import 'package:demo/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>Authcontroller(), fenix: true);
  }
}