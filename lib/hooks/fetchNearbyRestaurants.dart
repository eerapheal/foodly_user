// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly_user/controllers/reload_controllers.dart';
import 'package:foodly_user/models/api_error.dart';
import 'package:foodly_user/models/environment.dart';
import 'package:foodly_user/models/hook_models/hook_result.dart';
import 'package:foodly_user/models/restaurants.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

// Custom Hook
FetchHook useFetchRestaurants(bool? reload, {double? lat,double? lng}) {
  final restaurants = useState<List<Restaurants>?>(null);
  final isLoading = useState(false);
  final itemStatus = useState(true);
  final error = useState<Exception?>(null);
  final isMounted = useIsMounted(); // Hook to check if widget is mounted
  final reloadController = Get.find<ReloadController>();

// Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    // Check if data is already cached and not stale
    if (reloadController.restaurants.isNotEmpty && !reloadController.isDataStale) {
      restaurants.value = reloadController.restaurants;
      isLoading.value = false;
      return;
    }
    try {
      var url = Uri.parse('${Environment.appBaseUrl}/api/restaurant/$lat/$lng');
      print("res ulr ${'${Environment.appBaseUrl}/api/restaurant/$lat/$lng'}");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode the response body
        final decodeShops = jsonDecode(response.body);

        // Ensure that "data" contains the list of restaurants
        if (decodeShops["data"] is List) {
          final fetchedRestaurants = restaurantsFromJson(decodeShops["data"]);
          reloadController.restaurants = fetchedRestaurants; // Cache the fetched data
          restaurants.value = fetchedRestaurants;
          isLoading.value = false;
          itemStatus.value = decodeShops["status"];
        } else {
          // Handle the case where "data" is not a List
          isLoading.value = false;
          error.value = Exception("Data is not in the expected format");
        }
      } else {
        var error = apiErrorFromJson(response.body);
        isLoading.value = false;
       // error.value = Exception("API Error: ${error.message}");
      }
    } catch (e) {
      debugPrint(e.toString());
      if (isMounted()) {
        error.value = e as Exception?;
      }
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
    if(isMounted()) {
      isLoading.value = false;
      fetchData();
    }
  }

  // Return values
  return FetchHook(
    data: restaurants.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
    itemStatus: itemStatus.value
  );
}
