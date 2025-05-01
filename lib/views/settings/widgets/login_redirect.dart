import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/custom_container.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/views/auth/login_page.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginRedirection extends StatelessWidget {
  const LoginRedirection({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white, // Set consistent background color
      /*appBar:kIsWeb?null: AppBar(
        title: const Center(
          child: Text("Login to access ", style: TextStyle(
              color: Colors.white
          ),),
        ),
        backgroundColor: kPrimary,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),*/
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: CustomContainer(
            color: Colors.white,
            containerHieght: height,
            containerContent: Column(
              children: [
                Container(
                  width: width,
                  height: height / 2.5, // Adjusted height to avoid gray area
                  color: kWhite, // Match the background color
                  child: LottieBuilder.asset(
                    "assets/anime/delivery.json",
                    width: width,
                    height: height / 2.5, // Adjusted to avoid stretching
                  ),
                ),
                SizedBox(height: 20.h), // Added spacing between Lottie and button
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: screenButtonWidth(300), // Minimum width for the button
                    maxWidth: screenButtonWidth(400), // Maximum width or fallback
                  ),
                  child: CustomButton(
                    onTap: () {
                      //Get.to(() => const Login());
                      Get.toNamed(RouteNames.getSignInRoute());
                    },
                    color: kPrimary,
                    btnHieght: screenButtonHeight(70), // Adjust button height for better appearance
                    btnWidth: kIsWeb?350:(width - 40.w),
                    radius: 10,// Reduced width for better alignment
                    text: "L O G I N",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
