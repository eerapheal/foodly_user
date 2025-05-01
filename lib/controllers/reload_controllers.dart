import 'package:foodly_user/models/categories.dart';
import 'package:foodly_user/models/restaurants.dart';
import 'package:get/get.dart';
import 'package:foodly_user/models/foods.dart';

class ReloadController extends GetxController {
  final _foods = <Food>[].obs;
  final _foodsPromotion = <Food>[].obs;
  final _categories = <Categories>[].obs;

  final _restaurants = <Restaurants>[].obs;

  DateTime? _lastFetchTime;

  List<Food> get foods => _foods;
  List<Food> get foodsPromotion => _foodsPromotion;
  List<Categories> get categories => _categories;

  List<Restaurants> get restaurants => _restaurants;

  set foods(List<Food> value) {
    _foods.value = value;
    _lastFetchTime = DateTime.now(); // Update fetch time when data is set
  }
  set foodsPromotion(List<Food> value) {
    _foodsPromotion.value = value;
    _lastFetchTime = DateTime.now(); // Update fetch time when data is set
  }

  set categories(List<Categories> value) {
    _categories.value = value;
    _lastFetchTime = DateTime.now(); // Update fetch time when data is set
  }

  set restaurants(List<Restaurants> value) {
    _restaurants.value = value;
    _lastFetchTime = DateTime.now(); // Update fetch time when data is set
  }

  bool get isDataStale {
    if (_lastFetchTime == null) return true;
    return DateTime.now().difference(_lastFetchTime!) > const Duration(minutes: 1000);
  }

  void clearCache() {
    _foods.clear();
    _restaurants.clear();
    _foodsPromotion.clear();
    _categories.clear();
    _lastFetchTime = null;
    print("Cleared all items cache");
  }
}
