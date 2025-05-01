import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';

import 'package:foodly_user/common/show_snack_bar.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/common/utils/global_loading.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/address_controller.dart';
import 'package:foodly_user/controllers/app_setup_controller.dart';
import 'package:foodly_user/controllers/check_out_controller.dart';
import 'package:foodly_user/controllers/order_controller.dart';

import 'package:foodly_user/models/distance_time.dart';
import 'package:foodly_user/models/order_item.dart';
import 'package:foodly_user/models/restaurants.dart';
import 'package:foodly_user/services/distance.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:foodly_user/views/orders/payment.dart';
import 'package:foodly_user/views/orders/widgets/calculate_grand_total_with_redeem.dart';
import 'package:foodly_user/views/orders/widgets/calculate_redeem.dart';
import 'package:foodly_user/views/orders/widgets/long_item_tile_dbestech.dart';
import 'package:foodly_user/views/profile/shipping_address.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore: must_be_immutable
class MultiProductCheckout extends HookWidget {
  MultiProductCheckout({super.key, required this.restaurant});

  final Restaurants restaurant;

  @override
  Widget build(BuildContext context) {
    AddressController controller = Get.find<AddressController>();
    CartCheckoutController checkout = Get.find<CartCheckoutController>();
    final box = GetStorage();
    final orderController = Get.put(OrderController());
    double deliveryFee=0.0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Obx(
        () => orderController.paymentUrl.contains("https")
            ? const PaymentWebView()
            : Scaffold(
                backgroundColor: kWhite,
                appBar: AppBar(
                  backgroundColor: kWhite,
                  elevation: 0,
                    automaticallyImplyLeading:false,
                  leading: CommonBackButton(
                      onPressed: () {
                        orderController.clearOrderItems();
                        orderController.useRedeem = false;
                        Get.back();
                      },
                  ),
                  title: Center(
                      child: Text("Delivering To :  ${controller.userAddress}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: appStyle(12, kPrimary, FontWeight.w500))),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        ListView.builder(
                          shrinkWrap: true,
                                itemCount: checkout.orderItems.length,
                                itemBuilder: (context, i) {
                                  final lat = box.read("userLat");
                                  final lng = box.read("userLng");
                                  OrderItems orderItem = checkout.orderItems[i];
                                  DistanceTime distanceTime = Distance()
                                      .calculateDistanceTimePrice(
                                      lat,
                                      lng,
                                      restaurant.coords.latitude,
                                      restaurant.coords.longitude,
                                      10,
                                      Get.find<AppSetupController>().deliveryFee);

                                  double totalTime = 25 + distanceTime.time;

                                  double grandPrice =
                                      checkout.totalPrice + distanceTime.price;
                                  //here set the final price as orderPrice
                                  orderController.orderPrice=grandPrice;
                                  deliveryFee = distanceTime.price;
                                  Get.find<OrderController>().orderPrice= grandPrice;
                                  return LongItemTileDbestech(
                                      orderItem: orderItem,
                                      grandPrice: grandPrice,
                                      totalTime: totalTime,
                                      restaurantId: restaurant.id!,
                                      index:i);
                                }),
                        SizedBox(
                          height: 5.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: [
                              const Divider(),
                              const CalculateGrandTotalWithRedeem(),
                              SizedBox(
                                height: 5.h,
                              ),
                              const Divider(),
                              if(Get.find<OrderController>().redeemableAmount>0)
                                const CalculateRedeem(),
                            ],
                          ),
                        )
                      ],

                    ),
                  ),
                ),
                bottomNavigationBar: controller.defaultAddress == null
                    ? CustomButton(
                        onTap: () {
                          Get.to(() => const AddAddress());
                        },
                        radius: 9,
                        color: kPrimary,

                  btnHieght: screenButtonHeight(37),
                  btnWidth: kIsWeb ? 350 : (width - 40.w),
                        text: "Add  Default Address",
                      )
                    : orderController.isLoading
                        ?  Center(
                  child: Stack(
                    children: [
                     GlobalLoading()
                    ],
                  ),
                )
                    : Container(
                  color: Colors.transparent,
                  height: 80,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,

                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomButton(
                              btnHieght: screenButtonHeight(70),
                              btnWidth: kIsWeb ? 350 : (width - 40.w),
                              color: kPrimary,
                              onTap: () {

                                if (!isValidRestaurantId(restaurant.id!)) {
                                  if (kDebugMode) {
                                    print("Not placing order");
                                  }
                                  showCustomSnackBar(
                                      "This is a corrupted restaurant, cannot place the order");
                                  return;
                                }

                                Order order = Order(
                                  userId: controller.defaultAddress!.userId,
                                  orderItems: checkout.orderItems,
                                  orderTotal:
                                 orderController.finalAmount.toStringAsFixed(2),// checkout.totalPrice.toStringAsFixed(2),
                                  recipientCoords: [
                                    controller.defaultAddress!.latitude,
                                    controller.defaultAddress!.longitude
                                  ],
                                  deliveryFee: deliveryFee.toStringAsFixed(2),
                                  grandTotal:orderController.finalAmount.toStringAsFixed(2),
                                  deliveryAddress: controller.defaultAddress!.id,
                                  paymentMethod: orderController.paymentMethod,
                                  restaurantAddress: restaurant.coords.address,
                                  restaurantCoords: [
                                    restaurant.coords.latitude,
                                    restaurant.coords.longitude,
                                  ],
                                  restaurantId: restaurant.id!,

                                );
                                String orderData = orderToJson(order);

                                orderController.order = order;

                                orderController.createOrder(orderData, order, (paymentSuccess, paymentUrl) {

                                  if (paymentSuccess) {
                                    showCustomSnackBar(
                                      "Payment initiated successfully",
                                      isError: false,
                                      title: "Payment Success",
                                    );

                                    if (paymentUrl != null && paymentUrl.isNotEmpty) {
                                      // If paymentUrl exists, navigate to it
                                    }
                                  } else {
                                    showCustomSnackBar(
                                      "If you can not do payment, restart the app and try again",
                                      isError: true,
                                      title: "Payment",
                                      duration: const Duration(seconds: 5),
                                    );
                                  }
                                });

                              },
                              radius: appBorderRadius,

                              text: "P R O C E E D T O P A Y M E N T",
                            )),
                      ),
                    ],
                  )
                )
              ),
      ),
    );
  }
}

bool isValidRestaurantId(String restaurantId) {
  // Regular expression to match a 24-character hex string
  final regex = RegExp(r'^[0-9a-fA-F]{24}$');

  // Check if the length is exactly 24 and if it matches the pattern
  if (restaurantId.length == 24 && regex.hasMatch(restaurantId)) {
    return true; // Valid
  } else {
    return false; // Invalid
  }
}
