// ignore_for_file: unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/cached_image_loader.dart';
import 'package:foodly_user/common/global_network_message.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/shimmers/categories_shimmer.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/catergory_controller.dart';
import 'package:foodly_user/controllers/location_controller.dart';
import 'package:foodly_user/hooks/fetchCategories.dart';
import 'package:foodly_user/models/categories.dart';
import 'package:foodly_user/views/categories/more_categories.dart';
import 'package:get/get.dart';

class CategoriesWidget extends HookWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();
    final hookResult = useFetchCategories();
    final categoryItems = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;

    if (categoryItems == null || categoryItems.isEmpty) {
      return const CatergoriesShimmer();
    }

    return isLoading
        ? const CatergoriesShimmer()
        : Container(
            padding: const EdgeInsets.only(left: 12, top: 0),
            height: screenButtonHeight(110),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryItems.length + 1, // Add 1 for the empty box
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Empty box at index 0 with image
                  return GestureDetector(
                    onTap: () {
                      categoryController.updateCategory = ''; // Deselect others
                      categoryController.updateTitle = 'All Food';
                      Get.find<UserLocationController>().reloadItems=1;
                    },
                    child: Obx(() => Container(
                          margin: const EdgeInsets.only(right: 5),
                          padding: const EdgeInsets.only(top: 4),
                          width: screenButtonWidth(100),
                          height: screenButtonHeight(70),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: categoryController.categoryValue.isEmpty
                                  ? kSecondary
                                  : kOffWhite,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenButtonHeight(10),
                              ),
                              SizedBox(
                                height: screenButtonHeight(55),
                                child:
                                    Image.asset("assets/images/all_food.png"),
                              ),
                              ReusableText(
                                text: "All Food",
                                style: appStyle(
                                  screenFontSize(kFontSizeSmall),
                                  kDark,
                                  FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                }
                // Adjust index to account for the empty box
                Categories category = categoryItems[index - 1];
                return GestureDetector(
                  onTap: () {

                    Get.find<UserLocationController>().reloadItems= Get.find<UserLocationController>().reloadItems+1;
                   if (category.value == 'more') {
                      Get.toNamed(RouteNames.getAllCategoriesPage());
                    } else {
                      categoryController.updateCategory = category.id;
                      categoryController.updateTitle = category.title;
                    }
                  },
                  child: Obx(() => Container(
                        margin: const EdgeInsets.only(right: 5),
                        padding: const EdgeInsets.only(top: 4),
                        width: screenButtonWidth(100),
                        height: screenButtonHeight(70),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                categoryController.categoryValue == category.id
                                    ? kSecondary
                                    : kOffWhite,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenButtonHeight(10),
                            ),
                            SizedBox(
                              height: screenButtonHeight(55),
                              child: /*CachedImageLoader(
                                image: category.imageUrl,
                                imageHeight: screenButtonHeight(55),
                                imageWidth: screenButtonWidth(55),
                                fit: BoxFit.contain,
                              )*/Image.network(
                                category.imageUrl,
                                width: screenButtonWidth(55),
                                height: screenButtonHeight(55),
                                  fit: BoxFit.contain
                              ),
                            ),
                            ReusableText(
                              text: category.title,
                              style: appStyle(
                                screenFontSize(kFontSizeSmall),
                                kDark,
                                FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              },
            ),
          );
  }
}
