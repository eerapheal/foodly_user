import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/constants/constants.dart';

class CheckoutTile extends StatelessWidget {
  const CheckoutTile({
    super.key, required this.imageUrl, required this.title, required this.additives, required this.price,
    required this.quantity
  });

  final String imageUrl;
  final String title;
  final String price;
  final List<String> additives;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h, ),
      height: 90,
      width: width,
      decoration:  BoxDecoration(
          color: kGrayLight.withOpacity(0.2),
          borderRadius: const BorderRadius.all(Radius.circular(9))),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: SizedBox(
                  height: 80.h,
                  width: 80.h,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                ReusableText(
                    text: title, style: appStyle(11, kDark, FontWeight.w400)),

                const SizedBox(
                  height: 5,
                ),

                ReusableText(
                    text: "\$ ${double.parse(price).toStringAsFixed(2)}", style: appStyle(11, kDark, FontWeight.w400)),

                const SizedBox(
                  height: 5,
                ),


                SizedBox(
                  height: 28,
                  width: width * 0.55,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: additives.length,
                      itemBuilder: (context, i) {
                        final addittive = additives[i];
                        return Container(
                          margin: const EdgeInsets.only(right: 5),
                          decoration: const BoxDecoration(
                              color: kWhite,
                              borderRadius:
                              BorderRadius.all(Radius.circular(9))),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                              child: ReusableText(
                                  text: addittive,
                                  style: appStyle(10, kPrimary, FontWeight.w400)),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
