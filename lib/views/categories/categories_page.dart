import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/custom_container.dart';
import 'package:foodly_user/common/not_found.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly_user/common/utils/app_get_home.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/common/utils/global_loading.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/hooks/fetchFoodByCategory.dart';
import 'package:foodly_user/models/categories.dart';
import 'package:foodly_user/models/foods.dart';
import 'package:foodly_user/views/home/widgets/food_tile.dart';
import 'package:get/get.dart';

class CategoriesPage extends StatefulHookWidget {
  const CategoriesPage({super.key,  });

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  Categories? category;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeCategory();
  }

  Future<void> _initializeCategory() async {
    try {
      final passedCat = Get.arguments?["category"] as Categories?;
      if (passedCat != null) {
        setState(() {
          category = passedCat;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false; // Defer to hook for fetching by ID
        });
      }
    } catch (e) {
      print("Error initializing category: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  var catName="";
  @override
  Widget build(BuildContext context) {
    final catId = Get.parameters['catId'];
     catName = Get.parameters["name"]!;
    final hookResult = catId != null ? useFetchFoodByCategory(catId, "41007428") : null;

    if (isLoading) {
      return _buildLoadingScreen();
    }/* else if (category != null) {
      return _buildContent(category!);
    } */else if (hookResult != null && hookResult.isLoading) {
      return _buildLoadingScreen();
    } else if (hookResult != null && hookResult.data != null) {
      return _buildContent(hookResult.data!);
    } else {
      return _buildErrorScreen();
    }
  }

  Widget _buildLoadingScreen() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kIsWeb?padding:8, vertical: kIsWeb?10.h:40.h),
      child: Scaffold(
          backgroundColor: kOffWhite,
          appBar: AppBar(
            backgroundColor: kWhite,
            leading: const CommonBackButton(),
          ),
          body: Center(
            child: Stack(
              children: [GlobalLoading()],
            ),
          )),
    );
  }

  Widget _buildErrorScreen() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kIsWeb?padding:8, vertical: kIsWeb?10.h:40.h),
      child: const NotFoundPage(crash: true,),
    );
  }



  Widget _buildContent(List<Food> foods) {

    return Container(
      color: kWhite,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: kIsWeb?kWhite:kOffWhite,
          leading: const CommonBackButton(),
          actions: [
            IconButton(onPressed: ()=>AppGetHome().appGetHome(), icon:const Icon(Icons.home),)
          ],
          title: ReusableText(
              text: catName, style: appStyle(16, kGray, FontWeight.w600)),
        ),
        body: CustomContainer(
            color: kWhite,
            containerContent: isLoading
                ? const FoodsListShimmer()
                : Container(
              padding:
              EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              height: hieght,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    Food food = foods[index];
                    return Column(
                      children: [
                        CategoryFoodTile(
                          food: food,
                          onTap: () {
                            Get.toNamed(RouteNames.getDetailFoodRoute(food.title, food.id), arguments: {"food":food});
                          },
                        ),
                        //the below would show divider in web end
                        kIsWeb?const Divider(height: 1,color: kOffWhite,):const SizedBox.shrink()
                      ],
                    );
                  }),
            )),
      ),
    );
  }
}