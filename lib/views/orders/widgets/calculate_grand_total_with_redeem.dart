import 'package:flutter/cupertino.dart';
import 'package:foodly_user/controllers/order_controller.dart';
import 'package:foodly_user/views/restaurant/restaurants_page.dart';
import 'package:get/get.dart';

class CalculateGrandTotalWithRedeem extends StatelessWidget {
  const CalculateGrandTotalWithRedeem({super.key});
  @override
  Widget build(BuildContext context) {

    //first time when we come to this page, give the actual price
    // to final amount.
    //We don't want to change orderPrice, this is actual price of the orders
    //finalAmount is the one that's get deducted.
    //the below line may cause bug if the app is auto refreshed
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<OrderController>().finalAmount=Get.find<OrderController>().orderPrice;

    });

      return Obx(()=>RowText(
          first: "Order Grand Total (delivery fee included)",
          second:
          "\$ ${Get.find<OrderController>().finalAmount.toStringAsFixed(2)}"));
  }
}
