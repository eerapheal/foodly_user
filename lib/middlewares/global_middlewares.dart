import 'package:flutter/cupertino.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

class GlobalMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!isValidRoute(route)) {
      return const RouteSettings(name: '/not-found-page');
    }
    return null;
  }

  bool isValidRoute(String? route) {
    // List of valid base routes
    final validBaseRoutes = [
      RouteNames.initial,
      RouteNames.notFoundPage,
      RouteNames.splash,
      RouteNames.orderSuccess,
      RouteNames.orderSuccessWeb,
      RouteNames.clientOrders,
      RouteNames.restaurantInfo,
      RouteNames.detailFood,
      RouteNames.allCategories,
      RouteNames.category,
      RouteNames.restaurantDirection,
      RouteNames.allNearbyRestaurants,
      RouteNames.recommendations,
      RouteNames.fastestFoods,
      RouteNames.chatImageView
      // Add other valid base routes
    ];

    if (route == null) return false;

    // Strip query parameters and dynamic segments
    final uri = Uri.parse(route);
    final baseRoute = uri.path.split('/').take(2).join('/'); // Extract the first two parts: '/restaurant-info'

    return validBaseRoutes.contains(baseRoute);
  }
}
