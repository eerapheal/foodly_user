import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_user/common/address_modal.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/custom_textfield.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/show_snack_bar.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/common/utils/global_loading.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/address_controller.dart';
import 'package:foodly_user/controllers/cart_controller.dart';
import 'package:foodly_user/controllers/contact_controller.dart';
import 'package:foodly_user/controllers/counter_controller.dart';
import 'package:foodly_user/controllers/food_controller.dart';
import 'package:foodly_user/controllers/order_controller.dart';
import 'package:foodly_user/controllers/tab_controller.dart';
import 'package:foodly_user/hooks/fetchRestaurant.dart';
import 'package:foodly_user/hooks/fetchSingleFood.dart';
import 'package:foodly_user/models/cart_request.dart';
import 'package:foodly_user/models/foods.dart';
import 'package:foodly_user/models/response_model.dart';
import 'package:foodly_user/models/user_cart.dart';
import 'package:foodly_user/views/auth/login_page.dart';
import 'package:foodly_user/views/restaurant/restaurants_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FoodModal extends StatefulHookWidget {
  FoodModal({
    super.key,
    required this.userCart,
  });

  final UserCart userCart;

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodModal> {
  final TextEditingController _preferences = TextEditingController();
  final CounterController counterController = Get.put(CounterController());
  final PageController _pageController = PageController();
  final ContactController _controller = Get.put(ContactController());
  final FoodController foodController = Get.put(FoodController());

  bool restaurantDistance = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<ResponseModel> loadData() async {
    // Prepare the contact list for this user.
    // Get the restaurant info from Firebase.
    return _controller.asyncLoadSingleRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    // Use the custom hook to fetch single food data
    final hookResult = useFetchSingleFood(widget.userCart.productId.id);

    // Handle loading, error, and data states
    if (hookResult.isLoading) {
      return Center(
        child: Stack(
          children: [
            GlobalLoading()
          ],
        ),
      );
    }

    if (hookResult.error != null) {
      return Center(
        child: Stack(
          children: [
            GlobalLoading()
          ],
        ),
      );
    }

    if (hookResult.data == null) {
      return  Center(
        child: Stack(
          children: [
            GlobalLoading()
          ],
        ),
      );
    }

    final food = hookResult.data!;  // Safely access food now that it's non-null
    foodController.loadAdditives(food.additives);

    return Scaffold(
        backgroundColor: kLightWhite,
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(25)),
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 230.h,
                              child: PageView.builder(
                                  itemCount: food.imageUrl.length,
                                  controller: _pageController,
                                  onPageChanged: (i) {
                                    foodController.updatePage(i);
                                  },
                                  itemBuilder: (context, i) {
                                    return Container(
                                      height: 230.h,
                                      width: MediaQuery.of(context).size.width,
                                      color: kLightWhite,
                                      child: Image.network(
                                          fit: BoxFit.cover,
                                           food.imageUrl[i]
                                      )/*CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: food.imageUrl[i],
                                      )*/,
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 40.h,
                        left: 12,
                        right: 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {

                              },
                              child: CommonBackButton(
                                icon: Icons.favorite,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: CommonBackButton(
                                icon: Entypo.share,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          food.description,
                          maxLines: 8,
                          style: appStyle(10, kGray, FontWeight.w400),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        SizedBox(
                          height: 15.h,
                          child: ListView.builder(
                              itemCount: food.foodTags.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                final tag = food.foodTags[i];
                                return Container(
                                  margin: EdgeInsets.only(right: 5.h),
                                  decoration: BoxDecoration(
                                      color: kPrimary,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.r))),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: ReusableText(
                                          text: tag,
                                          style: appStyle(8, kLightWhite,
                                              FontWeight.w400)),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReusableText(text: "${food.title}", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: kPrimary,
                                borderRadius: BorderRadius.circular(18)
                              ),
                              child: ReusableText(text: "\$${food.price}", style: TextStyle(fontSize: 18, color:kOffWhite,fontWeight: FontWeight.w500)),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        ReusableText(
                            text: "Additives and Toppings",
                            style: appStyle(18, kDark, FontWeight.w600)),
                        SizedBox(height: 10.h),
                        Obx(() => Column(
                          children: List.generate(
                              foodController.additivesList.length, (i) {
                            final additive =
                            foodController.additivesList[i];
                            return CheckboxListTile(
                              title: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(additive.title),
                                  Text("\$ ${additive.price}")
                                ],
                              ),
                              contentPadding: EdgeInsets.zero,
                              value: additive.isChecked.value,
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              onChanged: (bool? newValue) {
                                additive.isChecked.value = newValue ?? false;
                                foodController.getTotalPrice();
                                foodController.getList();
                              },
                              activeColor: kPrimary,
                              checkColor: Colors.white,
                              controlAffinity:
                              ListTileControlAffinity.leading,
                              tristate: false,
                            );
                          }),
                        )),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
