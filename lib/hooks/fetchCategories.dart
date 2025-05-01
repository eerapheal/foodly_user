import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly_user/controllers/reload_controllers.dart';
import 'package:foodly_user/models/categories.dart';
import 'package:foodly_user/models/environment.dart';
import 'package:foodly_user/models/hook_models/hook_result.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

// Custom Hook
FetchHook useFetchCategories() {
  final categories = useState<List<Categories>?>(null);
  final isLoading = useState(false);
  final error = useState<Exception?>(null);
  final isMounted = useIsMounted(); // Hook to check if the widget is mounted

  final reloadController = Get.find<ReloadController>();

  Future<void> fetchData() async {
    if (!isMounted()) return;

    isLoading.value = true;

    // Check if data is already cached and not stale
    if (reloadController.categories.isNotEmpty && !reloadController.isDataStale) {
      categories.value = reloadController.categories;
      isLoading.value = false;
      return;
    }

    try {
      var url = Uri.parse('${Environment.appBaseUrl}/api/category/random/${kIsWeb?'web':'mobile'}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (isMounted()) { // Check if still mounted
          categories.value = categoriesFromJson(response.body);

          final fetchedCategories = categoriesFromJson(response.body);
          reloadController.categories = fetchedCategories; // Cache the fetched data
          categories.value = fetchedCategories;
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (isMounted()) { // Check if still mounted
        error.value = e as Exception?;
      }
    } finally {
      if (isMounted()) { // Check if still mounted
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
    if (isMounted()) { // Check if still mounted
      isLoading.value = true;
      fetchData();
    }
  }

  // Return values
  return FetchHook(
    data: categories.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
