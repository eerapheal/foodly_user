import 'package:flutter/cupertino.dart';
import 'package:foodly_user/common/utils/check_food.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:get/get.dart';

class FoodMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Extract the 'id' parameter from the route arguments
    final id = Get.parameters['id'];

    // Check if the 'id' is a valid food ID
    if (id == null || !CheckFood.isValidFoodId(id)) {
      return const RouteSettings(name: RouteNames.notFoundPage);
    }

    return null; // Allow navigation if the food ID is valid
  }
}
