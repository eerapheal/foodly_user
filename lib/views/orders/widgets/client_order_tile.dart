import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/entities/message.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/show_dialogue_app.dart';
import 'package:foodly_user/common/show_snack_bar.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/contact_controller.dart';
import 'package:foodly_user/hooks/fetchRestaurant.dart';
import 'package:foodly_user/models/client_orders.dart';
import 'package:foodly_user/models/response_model.dart';
import 'package:foodly_user/views/message/chat/view.dart';
import 'package:foodly_user/views/orders/order_details_page.dart';
import 'package:foodly_user/views/reviews/review_page.dart';
import 'package:get/get.dart';

class ClientOrderTile extends HookWidget {
  const ClientOrderTile({
    super.key,
    required this.order,
    this.isRating,

  });

  final ClientOrders order;
  final bool? isRating;
  Future<ResponseModel> loadData() async {

    //prepare the contact list for this user.
    //get the restaurant info from the firebase
    //get only one restaurant info
    return   Get.find<ContactController>().asyncLoadSingleRestaurant();
  }

  void loadChatData ()async{
    ResponseModel response = await  loadData();
    if(response.isSuccess==false){
      showCustomSnackBar(response.message!);
    }
  }
  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchRestaurant(order.restaurantId);
    var restaurantData ;//= hookResult.data;
    final load = hookResult.isLoading;

    if (load == false) {
      restaurantData = hookResult.data;

      if (restaurantData != null) {
        // Encoding to JSON string
        String jsonString = jsonEncode(restaurantData);


        // Decoding the JSON string back to Map
        Map<String, dynamic> resData = jsonDecode(jsonString);

        // Assigning the restaurant ID to the controller state
        Get.find<ContactController>().state.restaurantId.value = resData["_id"];

        // Load chat data
        loadChatData();
      } else {
        print("restaurantData is null");
      }
    }
    final int totalItems = order.orderItems.length;
    final String text = totalItems>1?"items":"item";

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        GestureDetector(
          onTap: (){
            if(isRating==null){
              Get.to(OrderDetailsPage(orderId: order.id,));
            }else{

              isRating == true
                  ? Get.toNamed(RouteNames.getRateOrderRoute(),
                    arguments: {
                    "order":order
                    }
                )
                  : Container();
            }
          },

          child: Container(
            height: screenButtonHeight(110),
            width: width,
            decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.all(Radius.circular(9))),
            child: Container(
              padding: const EdgeInsets.all(4),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //image and stars
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        child: Stack(
                          children: [
                            SizedBox(
                                height: kImageHeightTile,
                                width: kImageWidthTile,
                                child: Image.network(
                                  order.orderItems[0].foodId.imageUrl[0],
                                  fit: BoxFit.cover,
                                )),
                            Positioned(
                                bottom: 0,
                                child: Container(
                                  padding:
                                  const EdgeInsets.only(left: 6, bottom: 2),
                                  color: kGray.withOpacity(0.6),
                                  height: 16,
                                  width: width,
                                  child: RatingBarIndicator(
                                    rating: 5,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 15.0,
                                    direction: Axis.horizontal,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  //title and cart
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        ReusableText(
                            text: order.orderItems[0].foodId.title,
                            style: appStyle(screenFontSize(kFontSizeSmall), kDark, FontWeight.w400)),
                        ReusableText(
                            text:
                            "Delivery time: ${order.orderItems[0].foodId.time}",
                            style: appStyle(screenFontSize(kFontSizeSmaller), kGray, FontWeight.w400)),
                        const SizedBox(
                          height: 5,
                        ),
                        //additives
                        SizedBox(
                          height: 14,
                          width: width * 0.67,
                          child: MediaQuery.removePadding(
                            context: context,
                            removeBottom: true,
                            removeTop: true,

                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: order.orderItems[0].additives.length,
                                itemBuilder: (context, i) {
                                  final addittives =
                                  order.orderItems[0].additives[i];
                                  return Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: const BoxDecoration(
                                        color: kWhite,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(9))),
                                    child: Center(
                                      child: Padding(
                                        padding:  EdgeInsets.only(right: 4.w),
                                        child: ReusableText(
                                            text: addittives,
                                            style: appStyle(
                                                screenFontSize(kFontSizeSmaller), kPrimary, FontWeight.w400)),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        //items
                        Row(
                          children: [
                            const Icon(Icons.shopping_cart,color: kPrimary,),
                            const SizedBox(width: 5,),
                            ReusableText(
                                text: "Total $totalItems $text",
                                style: appStyle(screenFontSize(kFontSizeSmaller), kDark, FontWeight.w700))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 8.w,
          top: 10.h,
          child: Container(
            width: 60.h,
            height: kPriceHeight,
            decoration: const BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            child: Center(
              child: ReusableText(
                text: "\$ ${order.grandTotal}",
                style: appStyle(12, kLightWhite, FontWeight.bold),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10.w,
          bottom: 10.h,
          child: Container(
            width: 60.h,
            height: 19.h,
            decoration: const BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            child: Center(
              child: GestureDetector(
                onTap: () async {


                    ResponseModel status = await Get.find<ContactController>().goChat(restaurantData);
                    if(status.isSuccess==false){
                      showCustomSnackBar(status.message!, title: status.title!);
                    }

                },
                child: ReusableText(
                  text: "Chat",
                  style: appStyle(12, kLightWhite, FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        Positioned(
            right: 75.h,
            top: 10.h,
            child: Container(
              width: 19.h,
              height: 19.h,
              decoration: const BoxDecoration(
                  color: kSecondary,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: GestureDetector(
                onTap: () {},
                child: const Center(
                  child: Icon(
                    MaterialCommunityIcons.cart_plus,
                    size: 15,
                    color: kLightWhite,
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
