import'package:get/get.dart';
import 'package:demo/controllers/dasboard/dashboard_controller.dart';

class DashboardBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}