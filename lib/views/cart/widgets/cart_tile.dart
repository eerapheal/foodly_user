import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/show_snack_bar.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/cart_controller.dart';
import 'package:foodly_user/controllers/check_out_controller.dart';
import 'package:foodly_user/models/user_cart.dart';
import 'package:foodly_user/views/food/widgets/food_modal.dart';
import 'package:get/get.dart';

class CartTile extends HookWidget {
  const CartTile({super.key, required this.item, required this.itemId});

  final UserCart item;
  final int itemId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    CartCheckoutController checkoutController =
        Get.find<CartCheckoutController>();

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        GestureDetector(
          onTap: () {
            checkoutController.restList.forEach((item){
              print("the ids of restaurants are ${item}");
              // return true;
            });
            if (!checkoutController.checkUniqueResId(
                item.productId.id, item.productId.restaurant.id)) {
              showCustomSnackBar("They are not from the same restaurant");
            } else {
              checkoutController
                  .addCartItem(checkoutController.cartObs[itemId]);
            }
          },
          child: Obx(
            () => Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 90,
              width: width - 110,
              decoration: BoxDecoration(
                  color
                      : kWhite,
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                  border: Border.all(width: 1,color: checkoutController.tempCartList
                      .contains(item.productId.id)
                      ? kPrimary
                      : kWhite)
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        child: Stack(
                          children: [
                            SizedBox(
                                height: 75.h,
                                width: 75.h,
                                child: Image.network(
                                  item.productId.imageUrl[0],
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
                                    rating: item.productId.rating,
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
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: width * 0.45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            ReusableText(
                                text: item.productId.title,
                                style: appStyle(14, kDark, FontWeight.w400)),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                child: ReusableText(
                                    text:
                                    "Delivery time: ${item.productId.restaurant.time}",
                                    style: appStyle(12, kGray, FontWeight.w400)),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 28,
                              width: width * 0.67,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: item.additives.length,
                                  itemBuilder: (context, i) {
                                    final addittive = item.additives[i];
                                    return Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      decoration: BoxDecoration(
                                          color: checkoutController.tempCartList
                                              .contains(item.productId.id)
                                              ? kWhite
                                              : kOffWhite,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(9))),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: ReusableText(
                                              text: addittive,
                                              style: appStyle(
                                                  12, kGray, FontWeight.w400)),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        //total price
        Positioned(
          right: 0.w,
          top: 6.h,
          child: Container(
            width: 60.h,
            height: 19.h,
            decoration: const BoxDecoration(
                color: kPrimary,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            child: Center(
              child: ReusableText(
                text:
                    "\$ ${(checkoutController.cartObs[itemId].unitPrice * checkoutController.cartObs[itemId].quantity).toStringAsFixed(2)}",
                style: appStyle(12, kLightWhite, FontWeight.bold),
              ),
            ),
          ),
        ),
        //add and remove buttons
        Positioned(
            bottom: 22.h,
            right: 0,
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      if (checkoutController.cartObs[itemId].quantity < 20) {
                        checkoutController.cartObs[itemId].quantity++;
                        if(checkoutController.cartItems.contains(checkoutController.cartObs[itemId])){
                          checkoutController.calculateTotalPrice();
                        }
                      } else {
                        // Optionally, you can show a message if the quantity is already zero
                        print('Quantity cannot be more than 20');
                      }
                      checkoutController.cartObs.refresh();
                    },
                    child: const Icon(
                      AntDesign.pluscircle,
                      color: kPrimary,
                    )),
                SizedBox(
                  width: 6.w,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: ReusableText(
                      text: "${checkoutController.cartObs[itemId].quantity}",
                      style: appStyle(16, kDark, FontWeight.w500)),
                ),
                SizedBox(
                  width: 6.w,
                ),
                GestureDetector(
                    onTap: () {
                      if (checkoutController.cartObs[itemId].quantity > 1) {
                        checkoutController.cartObs[itemId].quantity--;
                       if(checkoutController.cartItems.contains(checkoutController.cartObs[itemId])){
                        /*   for(var cartItem in checkoutController.cartItems){
                             if(cartItem.productId.id==checkoutController.cartObs[itemId].productId.id){
                               print("item prices ${cartItem.quantity*cartItem.totalPrice}");
                               break;
                             }
                         }*/
                           checkoutController.calculateTotalPrice();
                       }
                      } else {
                        // Optionally, you can show a message if the quantity is already zero
                        print('Quantity cannot be less than zero');
                      }
                      checkoutController.cartObs.refresh();
                    },
                    child: const Icon(
                      AntDesign.minuscircle,
                      color: kPrimary,
                    ))
              ],
            )),
        //delete button
        Positioned(
            right: 85.h,
            top: 6.h,
            child: Container(
              width: 25.h,
              height: 25.h,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: GestureDetector(
                onTap: () {
                  //checkoutController.cartObs[itemId].id is the cart id
                  //
                  if(checkoutController.cartItems.contains(checkoutController.cartObs[itemId])){
                    checkoutController.cartItems.remove(checkoutController.cartObs[itemId]);
                    if(checkoutController.tempCartList.contains(item.productId.id)){
                      checkoutController.tempCartList.remove(item.productId.id);
                      checkoutController.restList.remove(item.productId.restaurant.id);
                      checkoutController.orderItems.removeWhere((x){

                       return x.cartItemId==item.id;
                      });
                    }
                    checkoutController.calculateTotalPrice();
                  }

                  print("removed product id ${checkoutController.cartObs[itemId].id}");
                  Get.find<CartController>().removeFormCart(checkoutController.cartObs[itemId].id);

                  checkoutController.cartObs.removeAt(itemId);
                },
                child: const Center(
                  child: Icon(
                    MaterialCommunityIcons.delete,
                    size: 30,
                    color: kRed,
                  ),
                ),
              ),
            )),
        //modal button
        Positioned(
            right: 85.h,
            bottom: 25.h,
            child: Container(
              width: 22.h,
              height: 22.h,
              decoration: const BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(11))),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // To make it full screen
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 90,
                        child: Column(
                          children: [
                            // Custom styled App Bar with arrow button
                            Container(
                              padding: EdgeInsets.only(top: 30.h, bottom: 10.h),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: kPrimary,
                                // Background color for the app bar
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pop(); // Close the modal
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: Colors.white, // Icon color
                                  ),
                                ),
                              ),
                            ),
                            // The rest of your modal content
                            Expanded(
                              child: FoodModal(
                                userCart: item,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward,
                    size: 25,
                    color: kLightWhite,
                  ),
                ),
              ),
            )),
        //divider
        Positioned(
            bottom: 3,
            left: 150,
            right: 150,
            child: Divider(
              color: kPrimary,
              thickness: 1,
            ))
      ],
    );
  }
}
