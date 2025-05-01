// Custom Hook
import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly_user/models/environment.dart';
import 'package:foodly_user/models/foods.dart';
import 'package:foodly_user/models/hook_models/hook_result.dart';
import 'package:http/http.dart' as http;

FetchHook useFetchSingleFood(String foodId) {
  final food = useState<Food?>(null); // Single food instead of a list
  final isLoading = useState(false);
  final error = useState<Exception?>(null);
  final isMounted = useIsMounted(); // Hook to check if widget is mounted

  Future<void> fetchData() async {
    if (!isMounted()) return;
    isLoading.value = true;

    try {
      final response = await http.get(Uri.parse('${Environment.appBaseUrl}/api/foods/$foodId'));

      if (response.statusCode == 200) {
        print("Response data: ${response.body}");
        if (isMounted()) {
          food.value = Food.fromJson(jsonDecode(response.body));  // Ensure this line works
        }
      } else {
        print("Failed to load data: ${response.body}");
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (isMounted()) {
        error.value = e as Exception?;
        print("Error occurred: $e");
      }
    } finally {
      if (isMounted()) {
        isLoading.value = false;
      }
    }
  }


  // Side Effect
  useEffect(() {
    fetchData(); // Fetch the food when the hook is used
    return null;
  }, const []);

  // Refetch Function
  void refetch() {
    if (!isMounted()) return; // Stop if not mounted
    isLoading.value = true;
    fetchData();
  }

  // Return values
  return FetchHook(
    data: food.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
