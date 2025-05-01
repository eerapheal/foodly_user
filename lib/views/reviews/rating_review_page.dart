import 'package:flutter/material.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/views/reviews/widgets/orders_to_rate.dart';

class RatingReview extends StatelessWidget {
  const RatingReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhite,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
            backgroundColor: kWhite,
            elevation: 0,
            centerTitle: true,
            leading: const CommonBackButton(),
            title: ReusableText(
              text: "Reviews and Ratings",
              style: appStyle(screenFontSize(kFontSizeLarge), Colors.black, FontWeight.w600),
            ),),
        body: const RateOrders(),
      ),
    );
  }
}