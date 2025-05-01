import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly_user/common/show_dialogue_app.dart';
import 'package:foodly_user/controllers/reload_controllers.dart';
import 'package:foodly_user/models/environment.dart';
import 'package:foodly_user/models/foods.dart';
import 'package:foodly_user/models/hook_models/hook_result.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

// Custom Hook
FetchHook useFetchFood(bool? reload, {double? lat, double? lng}) {
  var foods = useState<List<Food>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);
  final itemStatus = useState(true);
  final isMounted = useIsMounted();

  final reloadController = Get.find<ReloadController>();

  Future<void> fetchData() async {
    if (!isMounted()) return;

    isLoading.value = true;

    // Check if data is already cached and not stale
    if (reloadController.foods.isNotEmpty && !reloadController.isDataStale) {
      foods.value = reloadController.foods;
      isLoading.value = false;
      return;
    }

    try {
      print("url ${Uri.parse('${Environment.appBaseUrl}/api/foods/searchFoodsByCoords/$lat/$lng')}");
      final response = await http.get(
          Uri.parse('${Environment.appBaseUrl}/api/foods/searchFoodsByCoords/$lat/$lng'));
      if (response.statusCode == 200) {
        if (isMounted()) {
          var fetchedFoods = jsonDecode(response.body);
          final foodsData = fetchedFoods["data"];
          final foodsStatus = fetchedFoods["status"];
          fetchedFoods = foodFromJson(foodsData);
          reloadController.foods = fetchedFoods; // Cache the fetched data
          foods.value = fetchedFoods;
          isLoading.value = false;
          //check if a food is found within the area
          //false means not found
          itemStatus.value = foodsStatus;
          print("food list status ${itemStatus.value}");
        }
      } else {
        isLoading.value = false;
        foods.value=[];
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (isMounted()) {
        error.value = e is Exception ? e : Exception('Unknown error');
      }
    } finally {
      if (isMounted()) {
        isLoading.value = false;
      }
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, [reload]);

  void refetch() {
    if (isMounted()) {
      fetchData();
    }
  }

  return FetchHook(
    data: foods.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
    itemStatus: itemStatus.value,
  );
}

