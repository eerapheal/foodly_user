import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/models/environment.dart';
import 'package:foodly_user/models/hook_models/hook_result.dart';
import 'package:foodly_user/models/restaurants.dart';
import 'package:http/http.dart' as http;

// Custom Hook
FetchHook useFetchAllRestaurants(code) {
  final restaurants = useState<List<Restaurants>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);

  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      print("restaurant by code ${'${Environment.appBaseUrl}/api/restaurant/all/$code'}");
      final response =
          await http.get(Uri.parse('${Environment.appBaseUrl}/api/restaurant/all/$code'));

      if (response.statusCode == 200) {
        var rest = jsonDecode(response.body);
        restaurants.value = restaurantsFromJson(rest);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e, trace) {
      print("Trace of the error ${trace}");
      error.value = e as Exception?;
    } finally {
      isLoading.value = false;
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
    data: restaurants.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
