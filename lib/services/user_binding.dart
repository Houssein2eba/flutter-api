import "package:demo/controllers/auth_controller.dart";
import "package:demo/controllers/client/client_controller.dart";
import "package:demo/controllers/dasboard/dashboard_controller.dart";
import "package:demo/controllers/notification_controller.dart";
import "package:demo/controllers/order/single_order_controller.dart";
import "package:demo/controllers/role_controller.dart";
import "package:demo/controllers/stock/stocks_controller.dart";

import "package:get/get.dart";
import "package:demo/controllers/user/user_controller.dart";

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => RoleController(), fenix: true);
    Get.lazyPut(() => StocksController(), fenix: true);
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(()=>Authcontroller(), fenix: true);
    Get.lazyPut(() => Clientscontroller(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => SingleOrderController(), fenix: true);



  }
}
