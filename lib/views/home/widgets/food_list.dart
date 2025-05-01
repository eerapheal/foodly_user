// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/shimmers/app_shimmer.dart';
import 'package:foodly_user/common/show_dialogue_app.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/app_setup_controller.dart';
import 'package:foodly_user/views/home/widgets/food_widget.dart';
import 'package:foodly_user/hooks/fetchFoods.dart';
import 'package:foodly_user/models/foods.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FoodList extends HookWidget {
  FoodList({super.key, this.tag = false, this.reload = false});

  final bool? tag;
  final bool? reload;
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    // Fetching latitude and longitude from local storage
    var lat = box.read('userLat');
    var lng = box.read('userLng');

    // If latitude and longitude are null, show the shimmer effect
    if (lat == null || lng == null) {
      return _buildShimmer();
    } else {}

    // Fetch food data using the custom hook
    final hookResult = useFetchFood(reload, lat: lat, lng: lng);
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
      padding: const EdgeInsets.only(left: 12, top: 10),
      height: 180.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: foods.length,
        itemBuilder: (context, index) {
          Food food = foods[index];
          return FoodWidget(
            onTap: () {
              Get.toNamed(
                RouteNames.getDetailFoodRoute(food.title, food.id),
                arguments: {"food": food},
              );
            },
            image: food.imageUrl[0],
            title: food.title,
            price: food.price.toStringAsFixed(2),
            time: food.time,
            promotion: food.promotion,
            promotionPrice: food.promotionPrice,
            tag: tag,
            index: index,
          );
        },
      ),
    );
  }
}
