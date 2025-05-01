import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/custom_appbar.dart';
import 'package:foodly_user/common/custom_container.dart';
import 'package:foodly_user/common/heading.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/app_setup_controller.dart';
import 'package:foodly_user/controllers/catergory_controller.dart';
import 'package:foodly_user/controllers/location_controller.dart';
import 'package:foodly_user/controllers/promotion_controller.dart';
import 'package:foodly_user/views/home/all_nearby_restaurants.dart';
import 'package:foodly_user/views/home/fastest_foods_page.dart';
import 'package:foodly_user/views/home/recommendations.dart';
import 'package:foodly_user/views/home/widgets/categories_list.dart';
import 'package:foodly_user/views/home/widgets/category_foodlist.dart';
import 'package:foodly_user/views/home/widgets/food_list.dart';
import 'package:foodly_user/views/home/widgets/nearby_restaurants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dbestech_foods_promotion.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    //changes
    final categoryController = Get.find<CategoryController>();
    bool reload = false;

    return Scaffold(
      backgroundColor: kWhite,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.h), child: const CustomAppBar()),
      body: RefreshIndicator(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: CustomContainer(
                  color: kWhite,
                  containerContent: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const CategoriesWidget(),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() {
                        if (Get.find<UserLocationController>()
                                .reloadItems==1) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Promotions Section
                                Visibility(
                                  visible: Get.find<PromotionController>()
                                          .promotion ==
                                      true,
                                  child: Column(
                                    children: [
                                      HomeHeading(
                                        heading: "Foods on Promotion",
                                        onTap: () {
                                          // Navigate or handle tap if needed
                                        },
                                      ),
                                      DbestechFoodsPromotion(),
                                    ],
                                  ),
                                ),

                                // Nearby Restaurants Section
                                HomeHeading(
                                  heading:Get.find<AppSetupController>()
                                      .isItemStatusShops==false?
                                  "Top Restaurants"
                                      :"Nearby Restaurants",
                                  onTap: () {
                                    Get.toNamed(
                                        RouteNames.allNearbyRestaurants);
                                  },
                                ),
                                NearbyRestaurants(reload: reload),
                                const SizedBox(
                                  height: 10,
                                ),
                                // Try Something New Section
                                HomeHeading(
                                  heading:Get.find<AppSetupController>().isItemStatusItems==true?"Food near you":"Something new",//? "Try Something New":"New foodies near you",
                                  onTap: () {
                                    // Get.to(() => const Recommendations());
                                    Get.toNamed(RouteNames.recommendations);
                                  },
                                ),
                                FoodList(tag: false, reload: reload),

                                // Fastest Food Section
                                HomeHeading(
                                  heading:Get.find<AppSetupController>().isItemStatusItems==true?"Bests near you":"Best ratings",//? "Try Something New":"New foodies near you",
                                  onTap: () {
                                    // Get.to(() => const FastestFoods());
                                    Get.toNamed(RouteNames.fastestFoods);
                                  },
                                ),
                                FoodList(tag: true, reload: reload),
                              ],
                            ),
                          );
                        } else {
                          return CustomContainer(
                            containerContent: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HomeHeading(
                                  heading:
                                      "Explore ${categoryController.titleValue} Category",
                                  restaurant: true,
                                ),
                                CategoryFoodList(
                                    category: categoryController.categoryValue),
                              ],
                            ),
                          );
                        }
                      })
                    ],
                  ),
                ),
              ),
            ),
          ),
          onRefresh: () async {
            return Future.delayed(const Duration(seconds: 1), () {
              reload = true;
            });
          }),
    );
  }
}
