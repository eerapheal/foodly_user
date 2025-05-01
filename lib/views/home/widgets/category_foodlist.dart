import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/shimmers/app_shimmer.dart';
import 'package:foodly_user/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/app_setup_controller.dart';
import 'package:foodly_user/hooks/fetchCategory.dart';
import 'package:foodly_user/models/foods.dart';
import 'package:foodly_user/views/home/widgets/food_tile.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CategoryFoodList extends HookWidget {
   CategoryFoodList({super.key, required this.category});
  final String category;

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    // Fetching latitude and longitude from local storage
    var lat = box.read('userLat');
    var lng = box.read('userLng');

    final hookResult =
        useFetchCategory(category, lat: lat, lng: lng);
    final foods = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;
    final itemStatus = hookResult.itemStatus;

    if(itemStatus==false){
      WidgetsBinding.instance.addPostFrameCallback((_){
        // ShowDialogue().showDialog(title: "Item status",middleText: "Near your location there are no items\nLogin and change location to china");
        Get.find<AppSetupController>().isItemStatusItems=false;
      });
    }

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
            padding: EdgeInsets.only(left: kPaddingSmallMedium.w, top: 10.h, right: kPaddingSmallMedium.w),
            height: hieght,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  Food food = foods[index];
                  return CategoryFoodTile(
                    food: food,
                    onTap: () {
                      Get.toNamed(RouteNames.getDetailFoodRoute(food.title, food.id), arguments: {"food":food});
                    },
                  );
                }),
          );
  }
}
