import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/divida.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/utils/discount_calculator.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/order_controller.dart';
import 'package:foodly_user/controllers/points_controller.dart';
import 'package:foodly_user/models/order_item.dart';
import 'package:foodly_user/views/orders/checkout_tile.dart';
import 'package:foodly_user/views/restaurant/restaurants_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'calculate_grand_total_with_redeem.dart';
import 'calculate_redeem.dart';

class LongItemTileDbestech extends StatelessWidget {
  const LongItemTileDbestech({super.key, required this.orderItem,
    required this.grandPrice,
    required this.totalTime,
    required this.restaurantId,
    required this.index
  });
  final OrderItems orderItem;
  final double grandPrice;
  final double totalTime;
  final String restaurantId;
  final int index;
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final distance = box.read("distance");
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        // OrderTile(food: food),
        Container(
          width: width,
         // height: hieght / 3.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            margin: EdgeInsets.fromLTRB(0.w, 4.w, 0.w, 4.w),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r)),
            child: Column(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                //show the title only for the first restaurant
                if(index==0)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableText(
                              text: orderItem.restaurantTitle,
                              style: appStyle(
                                  26, kGray, FontWeight.bold)),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: kTertiary,
                            backgroundImage: NetworkImage(
                                orderItem.restaurantImageUrl),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      RowText(
                          first: "Business Hours",
                          second: orderItem.restaurantTime),
                      SizedBox(
                        height: 5.h,
                      ),
                    ],
                  ),
                //show tile for each item
                CheckoutTile(
                    imageUrl: orderItem.foodImageUrl,
                    title: orderItem.foodTitle,
                    additives: orderItem.additives,
                    price: orderItem.price,
                    quantity: int.parse(orderItem.quantity)
                ),


                SizedBox(
                  height: 5.h,
                ),
                RowText(
                    first: "Estimated Delivery Time",
                    second:
                    "${(distance ?? 0).toStringAsFixed(0)} mins"),

                SizedBox(
                  height: 5.h,
                ),
                RowText(
                    first: "Food Price",
                    second:
                    "\$ ${double.tryParse(orderItem.price ?? '0')!.toStringAsFixed(2)}"),


              ],
            ),
          ),
        ),
        //calcaulate redeem

      ],
    );
  }
}
