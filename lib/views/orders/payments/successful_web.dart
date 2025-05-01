import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/common_loading_screen.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/utils/app_get_home.dart';
import 'package:foodly_user/common/utils/global_loading.dart';
import 'package:foodly_user/common/values/common_error_screen.dart';
import 'package:foodly_user/constants/constants.dart' as appConst;
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/check_out_controller.dart';
import 'package:foodly_user/controllers/order_controller.dart';
import 'package:foodly_user/controllers/tab_controller.dart';
import 'package:foodly_user/hooks/fetchOrder.dart';
import 'package:foodly_user/models/environment.dart';
import 'package:foodly_user/models/loyalty_transaction.dart';
import 'package:foodly_user/models/order_details.dart';
import 'package:foodly_user/views/entrypoint.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class SuccessfulWeb extends StatefulHookWidget {
  SuccessfulWeb({super.key});

  @override
  State<SuccessfulWeb> createState() => _SuccessfulWebState();
}

class _SuccessfulWebState extends State<SuccessfulWeb> {
  final box = GetStorage();

  void addLoyaltyPoints(OrderController orderController) async {

    final userId = jsonDecode(box.read("userId"));
    final orderId = box.read("orderId");


    LoyaltyTransaction loyalty;

      final orderPrice = jsonDecode(box.read("orderPrice"));
      final finalAmount = jsonDecode(box.read("finalAmount"));
      print("total price ${box.read("totalPrice")}");
      final totalPrice = double.parse((box.read("totalPrice").toString()));
      print("My total orderPrice is ${orderPrice}");
      print("My finalAmount  is ${finalAmount}");
      loyalty = LoyaltyTransaction(
          userId: userId,
          orderId: orderId,
          points: orderController.useRedeem == false
              ? totalPrice.toInt()
              : (orderPrice - finalAmount)
              .toInt(),
          reason: orderController.useRedeem == false
              ? TransactionReason.earn
              : TransactionReason.redeem);


    print("Points updated ${loyalty.points}");

    Get.find<OrderController>().updateLoyaltyPoints(loyalty);
  }

  Future<void> removeCartItem() async {
    final cartCheckoutController = Get.find<CartCheckoutController>();
    final cartItemIds = cartCheckoutController.cartItemIds; // List of cart item IDs
    final url = '${Environment.appBaseUrl}/api/cart/remove-items'; // Your backend API URL
    final box = GetStorage();
    String token = box.read('token');
    String accessToken = jsonDecode(token);

    try {
      // Making the HTTP POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Include the token if necessary
        },
        body: jsonEncode({
          'itemIds':[], // Sending the list of cart item IDs
        }),
      );

      // Check the response status
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        Get.find<CartCheckoutController>().clearCart();
        // Optionally update the UI or local cart state here
      } else {
        print('Failed to remove items: ${response.body}');

        if (kDebugMode) {
          print('Failed to remove items: ${response.body}');
        }
      }
    } catch (error) {
      print('Error: $error');
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  final totalPrice = Get.find<CartCheckoutController>().totalPrice;

  void cleanItem(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<CartCheckoutController>().clearCart();
      removeCartItem();

      Get.find<OrderController>().setLoading=false;

    });

  }

  final orderController = Get.find<OrderController>();
  @override
  void initState() {
    // TODO: implement initState


    addLoyaltyPoints(orderController);
    cleanItem();
    //orderController.isLoading=true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Id ${box.read("orderId")}");
    final orderId = box.read("orderId");
    final hookResult = orderId != null ? useFetchOrder(orderId) : null;

    if (hookResult!.isLoading) {
      return const CommonLoadingScreen();
    } else if (hookResult != null && hookResult.data != null) {
      return _buildContent(hookResult.data!);
    } else {
      return const CommonErrorScreen();
    }
  }


  @override
  void dispose() {

    super.dispose();
  }

  Widget _buildContent(GetOrder order) {

    /*Timer(const Duration(seconds: 3), () {
      orderController.setIcon = true;
    });*/

/*
    if(Get.find<OrderController>().isLoading==false){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Scaffold(
          body: Stack(
            children: [
              Center(
                child: GlobalLoading(),
              )
            ],
          ),
        ),
      );
    }
*/

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding:  const EdgeInsets.fromLTRB(0,0, 20, 10),
                child: GestureDetector(
                    onTap: () {

                      if(Get.find<OrderController>().useRedeem==false) {

                          final totalPrice = double.parse((box.read("totalPrice").toString()));
                          Get.toNamed(RouteNames.getPointsGained(),arguments: {
                            "pointsGained":totalPrice.toInt()
                          });


                      }else{
                        Get.find<OrderController>().useRedeem=false;
                        Get.find<OrderController>().setLoading=false;
                        // Instead of navigating to MainScreen, update the tab index to navigate
                        final mainScreenController = Get.find<MainScreenController>();
                        mainScreenController.setTabIndex = 0;
                        Get.offAllNamed(RouteNames.getMainScreenRoute());
                      }

                    },

                    child:  const Icon(
                      AntDesign.closecircle,
                      color: appConst.kGrayLight,
                    )),
              )
            ],
          ),
          body:  Container(
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: appConst.hieght * 0.35.h,
                    width:appConst. width - 40,
                    decoration: BoxDecoration(
                        color: appConst.kOffWhite,
                        borderRadius: BorderRadius.all(Radius.circular(20.r))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          ReusableText(
                              text: "Payment Successful",
                              style: appStyle(13, appConst.kPrimary, FontWeight.normal)),
                          const Divider(
                            thickness: .2,
                            color: appConst.kGray,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Table(
                              children: [
                                TableRow(children: [
                                  ReusableText(
                                      text: "Order ID",
                                      style:
                                      appStyle(11, appConst.kPrimary, FontWeight.normal)),
                                  ReusableText(
                                      text: order.id,
                                      style:
                                      appStyle(11, appConst.kSecondary, FontWeight.normal)),
                                ]),
                                TableRow(children: [
                                  ReusableText(
                                      text: "Payment ID",
                                      style:
                                      appStyle(11, appConst.kPrimary, FontWeight.normal)),
                                  ReusableText(
                                      text: "113456",
                                      style:
                                      appStyle(11, appConst.kSecondary, FontWeight.normal)),
                                ]),
                                TableRow(children: [
                                  ReusableText(
                                      text: "Payment Method",
                                      style:
                                      appStyle(11, appConst.kPrimary, FontWeight.normal)),
                                  ReusableText(
                                      text: order.paymentMethod??"Unknown",
                                      style:
                                      appStyle(11, appConst.kSecondary, FontWeight.normal)),
                                ]),
                                TableRow(children: [
                                  ReusableText(
                                      text: "Payment status",
                                      style:
                                      appStyle(11, appConst.kPrimary, FontWeight.normal)),
                                  ReusableText(
                                      text: order.paymentStatus??"Unknown",
                                      style:
                                      appStyle(11, appConst.kSecondary, FontWeight.normal)),
                                ]),
                                TableRow(children: [
                                  ReusableText(
                                      text: "Order status",
                                      style:
                                      appStyle(11, appConst.kPrimary, FontWeight.normal)),
                                  ReusableText(
                                      text: order.orderStatus??"Unknown",
                                      style:
                                      appStyle(11, appConst.kSecondary, FontWeight.normal)),
                                ]),
                                TableRow(children: [
                                  ReusableText(
                                      text: "Amount",
                                      style:
                                      appStyle(11, appConst.kPrimary, FontWeight.normal)),
                                  ReusableText(
                                      text: "\$ ${order.orderTotal!.toStringAsFixed(2)}",
                                      style:
                                      appStyle(11, appConst.kSecondary, FontWeight.normal)),
                                ]),
                                TableRow(children: [
                                  ReusableText(
                                      text: "Restaurant",
                                      style:
                                      appStyle(11, appConst.kPrimary, FontWeight.normal)),
                                  ReusableText(
                                      text: order.restaurantId.title??"Unknown",
                                      style:
                                      appStyle(11, appConst.kSecondary, FontWeight.normal)),
                                ]),
                                TableRow(children: [
                                  ReusableText(
                                      text: "Date",
                                      style:
                                      appStyle(11, appConst.kPrimary, FontWeight.normal)),
                                  ReusableText(
                                      text: DateTime.now().toString().substring(0, 10),
                                      style:
                                      appStyle(11,appConst.kSecondary, FontWeight.normal)),
                                ]),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                      top: -20,
                      left: 0,
                      right: 0,
                      child: Icon(
                        size: 35,
                        AntDesign.checkcircle,
                        color: appConst.kPrimary,
                      )),
                  Positioned(
                    top: 52,
                    left: 0,
                    child: Container(
                        height: 10.h,
                        width: 10.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.r),
                              bottomRight: Radius.circular(20.r)),
                        )),
                  ),

                  Positioned(
                    top: 52,
                    right: 0,
                    child: Container(
                        height: 10.h,
                        width: 10.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              bottomLeft: Radius.circular(20.r)),
                        )),
                  ),

                ],
              ),
            ),
          )
      ),

    );}
}
