import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/common/utils/date.dart';
import 'package:foodly_user/common/utils/global_loading.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/points_controller.dart';
import 'package:foodly_user/models/loyalty_transaction.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class UserPoints extends GetView<PointsController> {
  const UserPoints({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          leading: const CommonBackButton(),
          title: const Text('User Points'),
          centerTitle: true,
          backgroundColor: kWhite,
        ),
        body: Obx(() {
          // Check if userPoints is empty
          if (controller.userPoints.isEmpty) {
            return  Center(
              child: Stack(
                children: [
                  GlobalLoading(),
                ],
              ),
            );
          }

          // Calculate total points
          int totalPoints = controller.userPoints.fold(0, (sum, point) => sum + point.points);

          // Sort points with usable ones at the top based on expiration date
          controller.userPoints.sort((a, b) {
            if (a.reason != TransactionReason.redeem && b.reason != TransactionReason.redeem) {
              return b.expiresAt!.compareTo(a.expiresAt!);
            } else if (a.reason != TransactionReason.redeem) {
              return -1;
            } else if (b.reason != TransactionReason.redeem) {
              return 1;
            } else {
              return b.expiresAt!.compareTo(a.expiresAt!);
            }
          });

          // Extract points information into widgets
          final points = controller.userPoints.map((point) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: _getTileColor(point.expiresAt!, point),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order ID and reason
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order ID: ${point.orderId}",
                                style: TextStyle(fontSize: kFontSizeSmall),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Reason: ${point.reason == TransactionReason.earn ? "earn" : "redeemed"}",
                                style: TextStyle(fontSize: kFontSizeMedium),
                              ),
                            ],
                          ),
                        ),
                        // User ID and expiration info
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "User ID: ${point.userId}",
                                style: TextStyle(fontSize: kFontSizeSmall),
                              ),
                              const SizedBox(height: 4),
                              point.reason != TransactionReason.redeem
                                  ? Text(
                                "Expires on: ${formatExpirationDate(point.expiresAt!)}",
                                style: TextStyle(
                                  color: kLightWhite,
                                  fontSize: kFontSizeMedium,
                                ),
                              )
                                  : Text(
                                "Used up for redeem",
                                style: TextStyle(
                                  color: kWhite,
                                  fontSize: kFontSizeMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const DashedLine(),
              ],
            );
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              // Call the method to refresh user points
              await controller.fetchUserPoints();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Display total points in an animated coin container
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 300.h,
                          ),
                          child: Lottie.asset(
                            'assets/anime/coin.json',
                            repeat: false,
                          ),
                        ),
                        ReusableText(
                          text: "$totalPoints",
                          style: GoogleFonts.greatVibes(
                            textStyle: const TextStyle(
                              fontSize: 44,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Your Points",
                    style: GoogleFonts.greatVibes(
                      textStyle: const TextStyle(
                        fontSize: 44,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...points,
                  const SizedBox(height: 16),
                  const DashedLine(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class DashedLine extends StatelessWidget {
  final double dashWidth;
  final double dashHeight;
  final Color color;

  const DashedLine({
    Key? key,
    this.dashWidth = 4.0,
    this.dashHeight = 1.0,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        (MediaQuery.of(context).size.width ~/ (dashWidth * 4)).toInt(),
            (index) => Container(
          width: dashWidth,
          height: dashHeight,
          color: color,
          margin: EdgeInsets.symmetric(horizontal: dashWidth),
        ),
      ),
    );
  }
}

Color _getTileColor(DateTime expirationDate, LoyaltyTransaction points ) {
  final currentDate = DateTime.now();
  final differenceInDays = expirationDate.difference(currentDate).inDays;

  if(points.reason==TransactionReason.redeem){
    return kGrayLight;
  }else{
    if (differenceInDays <= 0) {
      return kRed;  // Expiring today (or already expired)
    } else if (differenceInDays <= 3) {
      return Colors.yellow;  // Expiring in 3 days or less
    } else {
      return kPrimary;  // More than 3 days until expiration
    }
  }
}
