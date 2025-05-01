import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly_user/controllers/contact_controller.dart';
import 'package:foodly_user/models/environment.dart';
import 'package:foodly_user/models/hook_models/hook_result.dart';
import 'package:foodly_user/models/restaurants.dart';
import 'package:foodly_user/models/user_cart.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
// Custom Hook
FetchHook useFetchRestaurant(id) {
  final restaurant = useState<Restaurants?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);
  final controller = Get.find<ContactController>();
  final isMounted = useIsMounted();
  // Fetch Data Function
  Future<void> fetchData() async {
    isLoading.value = true;
    try {

      print("${Uri.parse('${Environment.appBaseUrl}/api/restaurant/byId/$id')}");
      final response =
          await http.get(Uri.parse('${Environment.appBaseUrl}/api/restaurant/byId/$id'));
      if (response.statusCode == 200) {
        if(isMounted()){

          var data = jsonDecode(response.body);
          Restaurants fetchedRestaurant = Restaurants.fromJson(data);
          restaurant.value = fetchedRestaurant;
          controller.state.restaurant.value = fetchedRestaurant;
        }

      } else {
        print("failed too get ${response.statusCode}");
                                                                                                                                                   throw Exception('Failed to load data');
      }
    } catch (e, trace) {
      if(isMounted()){
        print("${e.toString()}");
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
    isLoading.value = true;
    if (isMounted()) {
      isLoading.value = true;
      fetchData();
    }
  }

  // Return values
  return FetchHook(
    data: restaurant.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
