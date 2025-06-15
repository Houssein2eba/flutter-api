import 'package:demo/core/class/status_request.dart';
import 'package:demo/core/functions/handeling_data.dart';
import 'package:demo/data/remote/movement_data.dart';
import 'package:demo/models/stock_movement.dart';
import 'package:get/get.dart';

class StockMovementsController extends GetxController {
  List<StockMovement> movements = []; // Store filtered movements
  StatusRequest statusRequest = StatusRequest.none;

  String? typeFilter;
  String sortField = 'stockDate';
  String sortDirection = 'desc';
  String? id;
  MovementData movementData = MovementData(Get.find());

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
    fetchMovements();
  }

  void fetchMovements() async {
    statusRequest = StatusRequest.loading;
    update();
    
    var response = await movementData.getMovementsData(
      id: id!,
      type: typeFilter,
    );
    
    statusRequest = handlingData(response);
    
    if (StatusRequest.success == statusRequest) {
      if (response['movements'] != null) {
        movements = List<StockMovement>.from(
          response['movements'].map((x) => StockMovement.fromJson(x)),
        );
        applySorting(); 
        if(movements.isEmpty){
          statusRequest=StatusRequest.failure;
        }
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  void applySorting() {
    movements.sort((a, b) {
      int compare;
      if (sortField == 'quantity') {
        compare = a.quantity.compareTo(b.quantity);
      } else {
        compare = a.stockDate.compareTo(b.stockDate);
      }
      return sortDirection == 'asc' ? compare : -compare;
    });
  }

  void setTypeFilter(String? type) {
    typeFilter = type;
    fetchMovements(); // Fetch fresh data with the new filter
  }

  void clearFilters() {
    typeFilter = null;
    fetchMovements(); // Fetch fresh data without filters
  }
}