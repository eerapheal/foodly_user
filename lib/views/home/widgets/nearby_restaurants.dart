// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/global_network_message.dart';
import 'package:foodly_user/common/shimmers/app_shimmer.dart';
import 'package:foodly_user/common/shimmers/categories_shimmer.dart';
import 'package:foodly_user/common/shimmers/nearby_shimmer.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/app_setup_controller.dart';
import 'package:foodly_user/controllers/location_controller.dart';
import 'package:foodly_user/hooks/fetchNearbyRestaurants.dart';
import 'package:foodly_user/models/restaurants.dart';
import 'package:foodly_user/views/home/widgets/restaurant_widget.dart';
import 'package:foodly_user/views/restaurant/restaurants_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyRestaurants extends HookWidget {
  NearbyRestaurants({super.key, this.reload});
  final bool? reload;

  final box = GetStorage();
  final location = Get.find<UserLocationController>();

  @override
  Widget build(BuildContext context) {
    // Fetching latitude and longitude from local storage
    var lat = box.read('userLat');
    var lng = box.read('userLng');

    // If latitude and longitude are null, show the shimmer effect
    if (lat == null || lng == null) {
      return _buildShimmer();
    } else {}
    final location = Get.find<UserLocationController>();

    final hookResult = useFetchRestaurants(reload, lat: lat, lng: lng);
    // Fetch food data using the custom hook
    //final hookResult = useFetchFood(reload, lat: lat, lng: lng);
    final restaurants = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;
    final itemStatus = hookResult.itemStatus;

      if(itemStatus==false){
      WidgetsBinding.instance.addPostFrameCallback((_){
        Get.find<AppSetupController>().isItemStatusShops=false;

       // ShowDialogue().showDialog(title: "Item status",middleText: "Near your location there are no items\nLogin and change location to china");
      });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_){
          Get.find<AppSetupController>().isItemStatusShops=true;

          // ShowDialogue().showDialog(title: "Item status",middleText: "Near your location there are no items\nLogin and change location to china");
        });
      }

    // If food list is empty, show shimmer effect
    if (restaurants == null || restaurants.isEmpty) {
      return _buildShimmer();
    }

    // Return shimmer if still loading or error occurred
    if (isLoading || error != null) {
      return _buildShimmer();
    } else {
      return _buildFoodList(restaurants);
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
  Widget _buildFoodList(List<Restaurants> restaurants) {

    return Container(
            margin: const EdgeInsets.only(left: 12, top: 10),
            height: screenButtonHeight(198),

            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  Restaurants restaurant = restaurants[index];
                  return RestaurantWidget(
                    image: restaurant.imageUrl!,
                    title: restaurant.title!,
                    time: restaurant.time,
                    logo: restaurant.logoUrl!,
                    rating: "${restaurant.ratingCount} + reviews and ratings",
                    onTap: () {

                      location.setLocation(LatLng(restaurant.coords.latitude,
                          restaurant.coords.longitude));
                      Get.toNamed(
                        RouteNames.getRestaurantRoute(restaurant.title!, restaurant.id!),
                        arguments: {
                          "restaurant":restaurant
                        },
                      );

                    },
                  );
                }),
          );
  }
}
