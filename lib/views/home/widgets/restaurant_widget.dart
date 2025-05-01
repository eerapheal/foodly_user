import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/cached_image_loader.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/utils/user_review.dart';
import 'package:foodly_user/constants/constants.dart';

class RestaurantWidget extends StatelessWidget {
  const RestaurantWidget(
      {super.key,
      required this.image,
      required this.logo,
      required this.title,
      required this.time,
      this.onTap,
      required this.rating});

  final String image;
  final String logo;
  final String title;
  final String time;
  final String rating;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          width: screenButtonWidth(198),
          height: screenButtonHeight(198),
          decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Stack(
                  children: [
                    ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(appBorderRadius),
                          topLeft: Radius.circular(appBorderRadius),
                          bottomLeft: Radius.circular(appBorderRadius),
                          bottomRight: Radius.circular(35),
                        ),
                        child: /*CachedImageLoader(
                          image: image,
                          imageHeight: 120.h,
                          imageWidth: width * 0.8,
                          borderRadius: BorderRadius.circular(8),
                          fit: BoxFit.cover,
                        )*/Image.network(
                            image,
                            width: width * 0.8,
                            height: 120.h,
                            fit: BoxFit.cover
                        )),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        child: Container(
                          color: kLightWhite,
                          child: Container(
                            color: kSecondary,
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40)),
                              child: Image.network(
                                logo,
                                fit: BoxFit.cover,
                                height: screenButtonHeight(40),
                                width: screenButtonHeight(40),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                        text: title,
                        style: appStyle(screenFontSize(kFontSizeSmall), kDark, FontWeight.w700)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                            text: "Delivery",
                            style: appStyle(9, kGray, FontWeight.w500)),
                        ReusableText(
                            text: time,
                            style: appStyle(9, kGray, FontWeight.w500)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingBarIndicator(
                          rating: 5,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: kPrimary,
                          ),
                          itemCount: 5,
                          itemSize: 15.0,
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ReusableText(
                            text: "${UserReview.review(rating)} reviews",
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
