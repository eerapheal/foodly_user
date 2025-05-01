import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/back_ground_container.dart';
import 'package:foodly_user/common/custom_container.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/hooks/fetchAddresses.dart';
import 'package:foodly_user/models/all_addresses.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:foodly_user/views/profile/shipping_address.dart';
import 'package:foodly_user/views/profile/widgets/addresses_list.dart';
import 'package:get/get.dart';

class Addresses extends HookWidget {
  const Addresses({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAdresses();
    final List<AddressesList> addresses = hookResult.data;
    final isLoading = hookResult.isLoading;


    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(
            backgroundColor: kWhite,
            elevation: 0,
            leading: const CommonBackButton(),
            centerTitle: true,
            title: ReusableText(
              text: "Addresses",
              style: appStyle(
                  screenFontSize(kFontSizeLarge), kDark, FontWeight.w600),
            ),
          ),
          body: CustomContainer(
              color: kWhite,
              containerContent: Stack(
                children: [
                  isLoading
                      ? const FoodsListShimmer()
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          width: width,
                          height: hieght,
                          child: AddressList(addresses: addresses),
                        ),
                  Positioned(
                      bottom: 100,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: kIsWeb
                                ? 350
                                : (width - 40.w), // Set max width constraint
                          ),
                          child: CustomButton(
                            btnHieght: screenButtonHeight(70),
                            btnWidth: kIsWeb ? 350 : (width - 40.w),
                            radius: appBorderRadius,
                            text: "Add Address",
                            onTap: () {
                             // Get.to(() => const AddAddress());
                              Get.toNamed(RouteNames.getAddAddress());
                            },
                          ),
                        ),
                      ))
                ],
              ))),
    );
  }
}
