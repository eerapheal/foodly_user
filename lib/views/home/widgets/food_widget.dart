import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/cached_image_loader.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/constants/constants.dart';

class FoodWidget extends StatelessWidget {
     FoodWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.time,
      this.onTap, required this.price, required this.index, this.promotion, this.promotionPrice, this.tag});

  final String image;
  final String title;
  final String price;
  final String time;
  bool? promotion;
  double? promotionPrice;
  bool? tag;
  final int  index;
  final void Function()? onTap;

  final texts =[
    "Best \nin Town",
    "Most \nLiked",
    "Most \nVisited",
    "Very \ncheap",
    "Exotic \nTaste",
    "New \nin Town",
    "Old \nin Town",
    "New \nTaste"

  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 198.h,
          height: 180.h,
          decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(appBorderRadius))),
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(appBorderRadius)),
                      child: /*CachedImageLoader(
                        image: image,
                        imageHeight: 114.h,
                        imageWidth: width*0.8,
                        fit: BoxFit.fill,
                      )*/Image.network(
                          image,
                          width: width * 0.8,
                          height: 114.h,
                          fit: BoxFit.cover
                      ),
                    ),
                    if (tag==true)
                    Positioned(
                      left: 0,
                        bottom: 0,
                        child: Container(
                          height: screenButtonHeight(80),
                          width: screenButtonWidth(80),
                          decoration: BoxDecoration(
                          color: index%2==0?kSecondary:kPrimary,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(80),
                            bottomLeft: Radius.circular(appBorderRadius)
                          ),

                        ),
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.only(left: 12,  bottom: 14),
                            child: Text(texts[index], style: appStyle(
                                screenFontSize(kFontSizeSmall), kWhite, FontWeight.bold),),
                          ),
                    ))
                  ],
                )
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: screenButtonWidth(120),
                                  child: ReusableText(
                                        text: title,
                                        style: appStyle(screenFontSize(kFontSizeSmall), kDark, FontWeight.w700)),
                                  ),
                              ),

                              ReusableText(
                              text: "\$$price",
                              style: appStyle(screenFontSize(kFontSizeSmall), kPrimary, FontWeight.w500)),
                        ],
                      ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                            text: "Delivery time",
                            style: appStyle(9, kGray, FontWeight.w500)),
                        ReusableText(
                            text: time,
                            style: appStyle(9, kGray, FontWeight.w500)),
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
