import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/global_network_message.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/common/utils/global_loading.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/hooks/fetchRecommendations.dart';
import 'package:foodly_user/models/foods.dart';
import 'package:foodly_user/views/food/widgets/food_tile.dart';

class Recommendations extends HookWidget {
  const Recommendations({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchRecommendations("41007428", true);
    final foods = hookResult.data;
    final isLoading = hookResult.isLoading;

    if(foods==null||foods.length==0){
     return Container(
       padding: EdgeInsets.symmetric(horizontal: padding),
       child: Scaffold(
          appBar: AppBar(
            backgroundColor: kOffWhite,
            elevation: 0,
            leading: const CommonBackButton(),
          ),
          body: Center(
            child:  GlobalLoading(),
          ),
        ),
     )      ;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      color: kWhite,
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: kWhite,
            surfaceTintColor: Colors.transparent,
            leading: const CommonBackButton(),
           actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.grid_view),
            ),
          ],
          title: ReusableText(
              text: "Recommendations", style: appStyle(16, kGray, FontWeight.w600)),
        ),
        body: isLoading
            ? const FoodsListShimmer()
            : Padding(
              padding: EdgeInsets.symmetric(horizontal: kPaddingSmallMedium),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
                  height: hieght,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),

                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: foods.length,
                        itemBuilder: (context, i) {
                          Food food = foods[i];
                          return FoodTile(food: food);
                        }),
                  ),
                ),
            ),
      ),
    );

  }
}