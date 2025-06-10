
import 'package:demo/core/class/status_request.dart';
import 'package:demo/core/functions/handeling_data.dart';
import 'package:demo/data/remote/client_order_data.dart';
import 'package:demo/models/order.dart';
import 'package:get/get.dart';

class ClientOrdersController extends GetxController {
  ClientOrderData clientOrderData = ClientOrderData(Get.find());
  String? id;
  List<Order> orders = [];
  StatusRequest statusRequest = StatusRequest.none;

  @override
  void onInit() {
    fetchClientOrders();
    id=Get.arguments['id'];
    super.onInit();
  }

  fetchClientOrders() async {
    statusRequest = StatusRequest.loading;
    update();
    var response= await clientOrderData.getClientOrdersData(id: id!);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      for (var element in response['orders']) {
        orders.add(Order.fromJson(element));
      }
    }
    update();

  }
}
