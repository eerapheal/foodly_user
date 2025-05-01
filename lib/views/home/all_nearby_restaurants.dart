import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/common_loading_screen.dart';
import 'package:foodly_user/common/custom_appbar.dart';
import 'package:foodly_user/common/global_network_message.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly_user/common/utils/app_get_home.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/common/utils/global_loading.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/hooks/fetchAllNearbyRestaurants.dart';
import 'package:foodly_user/models/restaurants.dart';
import 'package:foodly_user/views/home/widgets/restaurant_tile.dart';

class AllNearbyRestaurants extends HookWidget {
  const AllNearbyRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAllRestaurants("41007428");
    final restaurants = hookResult.data;
    final isLoading = hookResult.isLoading;

    if(restaurants==null||restaurants.length==0){
      return   CommonLoadingScreen();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      color: kWhite,

      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kWhite,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          leading: const CommonBackButton(),
          actions: [
            IconButton(
              onPressed: () {
                AppGetHome().appGetHome();
              },
              icon: const Icon(Icons.grid_view),
            ),
          ],
          title: ReusableText(
              text: "Near by Restaurants",
              style: appStyle(16, kGray, FontWeight.w600)),
        ),
        body: isLoading
            ? const FoodsListShimmer()
            : Padding(
              padding:  EdgeInsets.symmetric(horizontal: kPaddingSmallMedium.w),
              child: Container(
                  padding: EdgeInsets.symmetric( vertical: 10.h),
                  height: hieght,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),

                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: restaurants.length,
                        itemBuilder: (context, i) {
                          Restaurants restaurant = restaurants[i];
                          return RestaurantTile(restaurant: restaurant);
                        }),
                  ),
                ),
            ),
      ),
    );
  }
}
