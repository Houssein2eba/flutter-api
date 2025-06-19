import 'package:demo/core/class/status_request.dart';
import 'package:demo/core/functions/handeling_data.dart';
import 'package:demo/data/remote/movement_data.dart';
import 'package:demo/models/stock_movement.dart';
import 'package:get/get.dart';

class StockMovementsController extends GetxController {
  List<StockMovement> movements = [];
  StatusRequest statusRequest = StatusRequest.none;

  String? typeFilter;
  String sortField = 'stockDate';
  String sortDirection = 'desc';
  String? id;
  int currentPage = 1;
  int lastPage = 1;
  RxBool isLoadingMore = false.obs;
  bool hasMore = true;
  MovementData movementData = MovementData(Get.find());

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
    fetchMovements();
  }

  Future<void> fetchMovements({bool reset = true}) async {
    if (reset) {
      statusRequest = StatusRequest.loading;
      currentPage = 1;
      movements.clear();
      update();
    }

    var response = await movementData.getMovementsData(
      id: id!,
      type: typeFilter,
      page: currentPage,
    );

    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      if (response['movements'] != null) {
        final newMovements = List<StockMovement>.from(
          response['movements'].map((x) => StockMovement.fromJson(x)),
        );
        
        if (reset) {
          movements = newMovements;
        } else {
          movements.addAll(newMovements);
        }
        
        applySorting();
        currentPage = response['meta']['current_page'] ?? currentPage;
        lastPage = response['meta']['last_page'] ?? lastPage;
        hasMore = currentPage < lastPage;
        
        if (movements.isEmpty) {
          statusRequest = StatusRequest.failure;
        }
      } else {
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  Future<void> loadMoreMovements() async {
    if (isLoadingMore.value || !hasMore) return;
    
    isLoadingMore.value = true;
    update(); // Notify listeners about loading state change
    
    try {
      currentPage++;
      await fetchMovements(reset: false);
    } finally {
      isLoadingMore.value = false;
      update(); // Notify listeners that loading is complete
    }
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
    update(); // Notify UI to rebuild after sorting
  }

  void setTypeFilter(String? type) {
    typeFilter = type;
    fetchMovements(); // Reset pagination when filter changes
  }

  void clearFilters() {
    typeFilter = null;
    fetchMovements(); // Reset pagination when clearing filters
  }
}