import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/back_ground_container.dart';
import 'package:foodly_user/common/custom_container.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly_user/common/utils/app_get_home.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/hooks/fetchAllCategories.dart';
import 'package:foodly_user/models/categories.dart';
import 'package:foodly_user/views/categories/categories_page.dart';
import 'package:get/get.dart';

class AllCategories extends HookWidget {
  const AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAllCategories();
    final categories = hookResult.data;
    final isLoading = hookResult.isLoading;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kIsWeb ? kWhite : kOffWhite,
          centerTitle: true,
          leading: const CommonBackButton(),
          actions: [
            IconButton(
              onPressed: () {
                AppGetHome().appGetHome();
              },
              icon: const Icon(Icons.home),
            ),
          ],
          title: ReusableText(
              text: "Categories", style: appStyle(16, kGray, FontWeight.w600)),
        ),
        body: isLoading
            ? const FoodsListShimmer()
            : CustomContainer(
          color: kWhite,
          containerContent: Container(
            padding: const EdgeInsets.only(left: 0, top: 10, right: 0),
            height: hieght,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  Categories category = categories[index];
                  return Column(
                    children: [
                      Container(
                        color: kOffWhite,
                        child: ListTile(
                          onTap: () {

                            Get.toNamed(
                                RouteNames.getCategory(category.title,category.id),
                                arguments: {
                                  "category":category,
                                  "catId":category.id

                                }
                            );
                          },
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: kGrayLight,
                            child: Image.network(
                              category.imageUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                          title: ReusableText(
                              text: category.title,
                              style: appStyle(
                                  12, kGray, FontWeight.normal)),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: kGray,
                            size: 15,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.white,
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
