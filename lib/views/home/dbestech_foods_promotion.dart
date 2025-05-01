
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/global_network_message.dart';
import 'package:foodly_user/common/shimmers/app_shimmer.dart';
import 'package:foodly_user/common/shimmers/categories_shimmer.dart';
import 'package:foodly_user/common/shimmers/nearby_shimmer.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/location_controller.dart';
import 'package:foodly_user/hooks/fetchNearbyRestaurants.dart';
import 'package:foodly_user/hooks/fetchPromotionFood.dart';
import 'package:foodly_user/hooks/fetchRecommendations.dart';
import 'package:foodly_user/models/restaurants.dart';
import 'package:foodly_user/views/home/widgets/dbestech_food_promotion_tile.dart';
import 'package:foodly_user/views/home/widgets/food_widget.dart';
import 'package:foodly_user/views/home/widgets/restaurant_widget.dart';
import 'package:foodly_user/views/restaurant/restaurants_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/app_style.dart';
import '../../common/reusable_text.dart';
import '../../common/shimmers/foodlist_shimmer.dart';
import '../../common/shimmers/shimmer_widget.dart';
import '../../common/utils/common_back_button.dart';
import '../../common/utils/global_loading.dart';
import '../../constants/constants.dart';
import '../../models/foods.dart';
import '../food/food_page.dart';
import '../food/widgets/food_tile.dart';
import 'package:http/http.dart' as http;

class DbestechFoodsPromotion extends HookWidget {
   DbestechFoodsPromotion({super.key});
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    // Fetching latitude and longitude from local storage
    var lat = box.read('userLat');
    var lng = box.read('userLng');

    // If latitude and longitude are null, show the shimmer effect
    if (lat == null || lng == null) {
      return _buildShimmer();
    } else {
    }

    final hookResult = useFetchPromotionFoods(lat:lat,lng:lng);
    final foods = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;

    // If food list is empty, show shimmer effect
    if (foods == null || foods.isEmpty) {
      return _buildShimmer();
    }

    // Return shimmer if still loading or error occurred
    if (isLoading || error != null) {
      return _buildShimmer();
    } else {
      return _buildFoodList(foods);
    }
  }

   // Shimmer effect widget for loading state
   Widget _buildShimmer() {
     return AppShimmer(
       shimmerHieght: screenButtonHeight(160),
       shimmerWidth: screenButtonWidth(180),
       shimmerRadius: 10,
     );
   }

   // Widget to build food list once data is ready
   Widget _buildFoodList(List<Food> foods) {
    return Container(
        margin: const EdgeInsets.only(left: 12, top: 10),
        height: screenButtonHeight(180),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: foods.length,
            itemBuilder: (context, index) {

              Food food = foods[index];
              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(appBorderRadius),
                ),
                width: screenButtonWidth(180),
                child: DBestechPromotionTile(
                  onTap: () {
                    Get.toNamed(RouteNames.getDetailFoodRoute(food.title, food.id), arguments: {"food":food});
                  },
                  image: food.imageUrl[0],
                  title: food.title,
                  price: food.price.toStringAsFixed(2),
                  time: food.time,
                  promotion: food.promotion,
                  promotionPrice: food.promotionPrice,
                ),
              );
            }),
      );
  }
}
