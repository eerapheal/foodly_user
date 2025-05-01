import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/order_controller.dart';
import 'package:foodly_user/controllers/tab_controller.dart';
import 'package:foodly_user/views/entrypoint.dart';
import 'package:foodly_user/views/home/home_page.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/constants.dart';

class PointsBonusAnimation extends StatefulWidget {
  final int points;

  const PointsBonusAnimation({Key? key, required this.points})
      : super(key: key);

  @override
  _PointsBonusAnimationState createState() => _PointsBonusAnimationState();
}

class _PointsBonusAnimationState extends State<PointsBonusAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            //text at the top
            Positioned(
              top: 160,
              left: 0,
              right: 0,
              child: Center(
                child: ReusableText(
                  text: "You have gotten",
                  style: GoogleFonts.greatVibes(
                    textStyle: const TextStyle(
                      fontSize: 44, // Set the size of the text
                      color: Colors.black, // Set the text color
                      fontWeight:
                          FontWeight.bold, // You can also set the weight
                    ),
                  ),
                ),
              ),
            ),
            //<a href="https://lordicon.com/">Icons by Lordicon.com</a>
            //icons
            // Coin animation with centered text inside
            Center(
              child: Stack(
                alignment: Alignment.center,
                // Aligns the text in the center of the coin animation
                children: [
                  // Coin animation
                  Lottie.asset(
                    'assets/anime/coin.json',
                    repeat: false,
                    height:
                        300, // Adjust the size of the coin animation if needed
                  ),
                  // Centered "points" text inside the coin
                  ReusableText(
                    text: "${widget.points} points",
                    // Use the points value from widget
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
            //go home
            Positioned(
              top: 520,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: kIsWeb ? 350 : (width - 40.w), // Set max width constraint
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomButton(
                        onTap: () {
                          Get.find<OrderController>().useRedeem = false;
                          Get.find<OrderController>().setLoading = false;
                          // Instead of navigating to MainScreen, update the tab index to navigate
                          final mainScreenController =
                              Get.find<MainScreenController>();
                          mainScreenController.setTabIndex = 0;
                          /*Get.offUntil(
                            GetPageRoute(
                              settings: RouteSettings(
                                  name: RouteNames.getMainScreenRoute()),
                              page: () =>
                                  MainScreen(), // Replace with your main screen widget
                            ),
                            (route) => false, // Removes all routes
                          );*/
                          Get.to(
                                () => MainScreen(),
                            preventDuplicates: true, // Ensures only one instance exists
                          );
                        },
                        color: kPrimary,
                        text: 'Go home',
                        btnHieght: screenButtonHeight(70)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
