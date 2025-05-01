import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:foodly_user/common/custom_container.dart';
import 'package:foodly_user/common/utils/discount_calculator.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/order_controller.dart';
import 'package:foodly_user/controllers/points_controller.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:get/get.dart';

class CalculateRedeem extends StatelessWidget {
  const CalculateRedeem({super.key});


  @override
  Widget build(BuildContext context) {

    return Obx((){
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Use Points Button
                CustomButton(

                  btnHieght: screenButtonHeight(70),
                  btnWidth: screenButtonWidth(200),
                  radius: appBorderRadius,
                  text: "Redeem",
                  onTap: () {
                    if(Get.find<OrderController>().useRedeem==true){
                      //it's been used, so in this click restore the total
                      //amount
                      Get.find<OrderController>().finalAmount=
                          Get.find<OrderController>().finalAmount
                              +
                              Get.find<OrderController>().redeemableAmount;
                    }else{
                      //first time clicked and reduce from final amount
                      Get.find<OrderController>().finalAmount=
                          Get.find<OrderController>().finalAmount
                              -
                              Get.find<OrderController>().redeemableAmount;
                    }
                    //this toggles the buttons and animation
                    Get.find<OrderController>().useRedeem=!Get.find<OrderController>().useRedeem;
                  },
                ),
                // Points Display Container
                CustomButton(
                  btnHieght: screenButtonHeight(70),
                  btnWidth: screenButtonWidth(200),
                  radius: appBorderRadius,
                  text: "${Get.find<OrderController>().redeemableAmount.toStringAsFixed(2)} Points",
                  color: Get.find<OrderController>().useRedeem==true?kPrimary:  kRed,

                )
              ],
            ),
          ),
        );

    });
  }
}
