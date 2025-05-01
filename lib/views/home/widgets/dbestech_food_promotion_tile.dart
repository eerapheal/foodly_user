import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/utils/discount_calculator.dart';

import '../../../common/app_style.dart';
import '../../../common/cached_image_loader.dart';
import '../../../common/reusable_text.dart';
import '../../../constants/constants.dart';

class DBestechPromotionTile extends StatelessWidget {
  DBestechPromotionTile(
      {super.key,
        required this.image,
        required this.title,
        required this.time,
        this.onTap,
        required this.price,
        this.promotion,
        this.promotionPrice});

  final String image;
  final String title;
  final String price;
  final String time;
  bool? promotion;
  double? promotionPrice;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: screenButtonWidth(12)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: screenButtonHeight(180),
          decoration: const BoxDecoration(
              //color: kLightWhite,
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(appBorderRadius)),
              boxShadow: [

              ]),
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(appBorderRadius)),
                      child: /*CachedImageLoader(
                        image: image,
                        imageHeight: screenButtonHeight(114),
                        imageWidth: screenButtonWidth(width * 0.8),
                        fit: BoxFit.cover,
                      )*/Image.network(
                          image,
                          width: screenButtonWidth(width * 0.8),
                          height: screenButtonHeight(114),
                          fit: BoxFit.cover
                      ),
                    ),
                    if (promotion == true)
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent, // Adjusted color for promotion badge
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(appBorderRadius),
                              bottomRight: Radius.circular(appBorderRadius),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.local_offer, color: Colors.white, size: screenIconSize(14)),
                              SizedBox(width: 4.w),
                              Text(
                                "${DiscountCalculator.calculateDiscountPercentage(double.parse(price), promotionPrice!)}%", // Adjusted label
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenFontSize(14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: ReusableText(
                            text: title,
                            style: appStyle(screenFontSize(14), kDark, FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    // Price Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Original Price with Strikethrough
                        if (promotion == true)
                          Text(
                            "\$${price}",
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: screenFontSize(12),
                            ),
                          ),
                        // Discounted Price
                        ReusableText(
                          text: promotion == true
                              ? "\$${promotionPrice!.toStringAsFixed(2)}"
                              : "\$ $price",
                          style: appStyle(screenFontSize(14), kPrimary, FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

