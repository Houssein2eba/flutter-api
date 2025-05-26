import 'dart:convert';
import 'package:demo/models/stock.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:demo/services/stored_service.dart';

class StocksController extends GetxController {
  final RxList<Stock> stocks = <Stock>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString nextCursor = ''.obs;
  final RxBool hasMore = true.obs;
  final StorageService storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    loadStocks();
  }

  Future<void> loadStocks({bool loadMore = false}) async {
    if ((loadMore && !hasMore.value) || (loadMore && isLoadingMore.value) || (!loadMore && isLoading.value)) {
      return;
    }

    loadMore ? isLoadingMore(true) : isLoading(true);


    try {
      final token = storage.getToken();
      final url = loadMore && nextCursor.value.isNotEmpty
          ? 'http://192.168.100.13:8000/api/stocks?cursor=${nextCursor.value}'
          : 'http://192.168.100.13:8000/api/stocks';



      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );



      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (!loadMore) {
          stocks.clear();
        }

        final List<dynamic> stocksData = data['stocks'] ?? [];
        stocks.addAll(stocksData.map((item) => Stock.fromJson(item)));

        if (data['meta'] != null) {
          nextCursor.value = data['meta']['next_cursor']?.toString() ?? '';
          hasMore.value = data['meta']['has_more'] ?? false;
        }


      } else {
        throw Exception('Failed to load stocks: ${response.statusCode}');
      }
    } catch (e) {
      
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
      isLoadingMore(false);
    }
  }

  @override
  void onClose() {
    stocks.clear();
    super.onClose();
  }
}