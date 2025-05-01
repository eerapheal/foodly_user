import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly_user/controllers/promotion_controller.dart';
import 'package:foodly_user/controllers/reload_controllers.dart';

import '../models/environment.dart';
import '../models/foods.dart';
import '../models/hook_models/hook_result.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

FetchHook useFetchPromotionFoods({double? lat,double? lng}) {

  final foods = useState<List<Food>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);
  final isMounted = useIsMounted(); // Hook to check if widget is mounted

  final reloadController = Get.find<ReloadController>();

  Future<void> fetchData() async {
    if (!isMounted()) return;

    isLoading.value = true;

    // Check if data is already cached and not stale
    if (reloadController.foodsPromotion.isNotEmpty && !reloadController.isDataStale) {
      foods.value = reloadController.foodsPromotion;
      isLoading.value = false;
      return;
    }

    try {
      Uri url ;
        url = Uri.parse('${Environment.appBaseUrl}/api/foods/promotional-foods/$lat/$lng');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if(isMounted()){
          final decodeBody = jsonDecode(response.body);
          final items = decodeBody["data"];
          final fetchedItems = foodFromJson(items);

          //final fetchedFoods = foodFromJson(response.body);
          reloadController.foodsPromotion = fetchedItems; // Cache the fetched data
          foods.value = fetchedItems;
          isLoading.value = false;
          if(foods.value!.isEmpty){
            Get.find<PromotionController>().setPromotion=false;
          }
        }
      } else {
        print("status code ${response.statusCode}");
        throw Exception('Failed to load data');
      }
    } catch (e) {
      error.value = e as Exception?;
    } finally {
      if (isMounted()) {
        isLoading.value = false;
      }
    }
  }

  // Side Effect
  useEffect(() {
    fetchData();
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  // Return values
  return FetchHook(
    data: foods.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
