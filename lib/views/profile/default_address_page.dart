import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/back_ground_container.dart';
import 'package:foodly_user/common/custom_container.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/address_controller.dart';
import 'package:foodly_user/models/all_addresses.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:get/get.dart';

class SetDefaultAddressPage extends StatelessWidget {
  const SetDefaultAddressPage({super.key, required this.address});

  final AddressesList address;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          backgroundColor: kWhite,
          centerTitle: true,
          leading: const CommonBackButton(),
          elevation: 0,
          title: ReusableText(
            text: "Change Default Address",
            style: appStyle(
                screenFontSize(kFontSizeMedium), kDark, FontWeight.w700),
          ),
        ),

        body: CustomContainer(
          color: kWhite,
          containerContent: Stack(
            children: [
              SizedBox(

                width: width,
                height: hieght,
                child: ListTile(
                  visualDensity: VisualDensity.compact,
                  leading: Padding(
                    padding: EdgeInsets.only(top: 0.0.r),
                    child: Icon(
                      SimpleLineIcons.location_pin,
                      color: kPrimary,
                      size: screenFontSize(28),
                    ),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  title: ReusableText(
                    text: address.addressLine1,
                    style: appStyle(screenFontSize(kFontSizeSmall), kGray, FontWeight.w500),
                  ),
                  subtitle: ReusableText(
                    text: address.postalCode,
                    style: appStyle(screenFontSize(kFontSizeSmall-1), kGray, FontWeight.normal),
                  ),
                ),
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
                      onTap: () {
                        controller.setDefaultAddress(address.id);

                      },
                      radius: 9,
                      color: kSecondary,
                      btnHieght: screenButtonHeight(70),
                      btnWidth: kIsWeb ? 350 : (width - 40.w),
                      text: "CLICK TO SET AS DEFAULT",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
