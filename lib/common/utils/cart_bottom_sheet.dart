import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/order_controller.dart';
import 'package:foodly_user/controllers/points_controller.dart';
import 'package:foodly_user/hooks/fetchRestaurant.dart';
import 'package:foodly_user/models/foods.dart';
import 'package:foodly_user/views/orders/multiple_item_checkout_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/check_out_controller.dart';
void showCartPaymentMethodsBottomSheet(BuildContext context, ) {

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            PaymentButton(
              image: 'assets/images/stripe.jpg',
              title: "Stripe",
            ),
            PaymentButton(
              image: 'assets/images/ppp.webp',
              title: "Paypal",
            ),
            PaymentButton(
              image: 'assets/images/paystack.png',
              title: "Paystack",
            ),
            SizedBox(height: 8.0),
          ],
        ),
      );
    },
  ).then((selectedPaymentMethod) {
    if (selectedPaymentMethod != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$selectedPaymentMethod selected')),
      );
    }
  });
}

class PaymentButton extends HookWidget {
  const PaymentButton({
    super.key,
    required this.image,
    required this.title,
    this.food,
  });

  final String image;
  final String title;
  final Food? food;

  @override
  Widget build(BuildContext context) {
    OrderController orderController = Get.find<OrderController>();
    //print("My cart objects ${jsonEncode(Get.find<OrderController>().userCart)}");
    final resId = Get.find<CartCheckoutController>().cartItems[0].productId.restaurant.id;
    final hookResult = useFetchRestaurant(resId);
    var restaurantData= hookResult.data;
    
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CircleAvatar(radius: 20, child: Image.asset(image)),
      ),
      title: Text(
        title,
      ),
      onTap: () {
        orderController.setPaymentMethod(title.capitalize ?? "STRIPE");
        if(restaurantData==null){
          if (kDebugMode) {
            print("Can not checkout");
          }
        }else{
        final box = GetStorage();
          var userId = box.read("userId");
          userId = jsonDecode(userId);

          Get.find<PointsController>().fetchUserTotalPoints(userId);
          Get.toNamed(RouteNames.getCheckoutPageRoute(), arguments: {
            "cartItems":restaurantData
          });
        }
      },
    );
  }
}