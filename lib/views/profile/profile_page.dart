import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_user/common/app_divider.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/custom_container.dart';
import 'package:foodly_user/common/customer_service.dart';
import 'package:foodly_user/common/show_dialogue_app.dart';
import 'package:foodly_user/common/show_snack_bar.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/app_setup_controller.dart';
import 'package:foodly_user/controllers/feedback_controller.dart';
import 'package:foodly_user/controllers/login_controller.dart';
import 'package:foodly_user/controllers/points_controller.dart';
import 'package:foodly_user/hooks/fetchServiceNumber.dart';
import 'package:foodly_user/models/login_response.dart';
import 'package:foodly_user/views/auth/widgets/login_redirect.dart';
import 'package:foodly_user/views/message/index.dart';
import 'package:foodly_user/views/orders/client_orders.dart';
import 'package:foodly_user/views/points/user_points.dart';
import 'package:foodly_user/views/profile/address.dart';
import 'package:foodly_user/views/profile/widgets/profile_appbar.dart';
import 'package:foodly_user/views/profile/widgets/tile_widget.dart';
import 'package:foodly_user/views/reviews/rating_review_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePage extends HookWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final upload = Get.put(UserFeedBackController());
    final setUpController = Get.find<AppSetupController>();
    LoginResponse? user;
    final box = GetStorage();
    String? token = box.read('token');

    final controller = Get.put(LoginController());

    if (token != null) {
      user = controller.getUserData();
    }

    final serviceNumber = useFetchCustomerService();

    return token == null
        ? const LoginRedirection()
        : Scaffold(
            backgroundColor: kWhite,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: const ProfileAppBar(),
                )),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: CustomContainer(
                      color: kIsWeb ? kWhite : kOffWhite,
                      containerContent: Column(
                        children: [
                          Container(
                            height: hieght * 0.07,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12.0, 0, 16, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 35,
                                            width: 35,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.shade100,
                                              backgroundImage:
                                                  NetworkImage(user!.profile),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  user.username,
                                                  style: appStyle(12, kGray,
                                                      FontWeight.w600),
                                                ),
                                                Text(
                                                  user.email,
                                                  style: appStyle(11, kGray,
                                                      FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //my orders
                          Container(
                            height: 100.h,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                TilesWidget(
                                  onTap: () {
                                    Get.toNamed(
                                      RouteNames.clientOrders,
                                    );
                                  },
                                  title: "My Orders",
                                  leading: Ionicons.cart_outline,
                                ),
                                TilesWidget(
                                  onTap: () {
                                    Get.toNamed(
                                        RouteNames.getReviewRatingRoute());
                                  },
                                  title: "Reviews and rating",
                                  leading: Ionicons.chatbubble_ellipses_outline,
                                ),
                              ],
                            ),
                          ),

                          const AppDivider(),
                          //my orders
                          Container(
                            height: 50.h,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                TilesWidget(
                                  onTap: () {
                                    print("user id is ${user!.id}");
                                    Get.to(
                                      () => const UserPoints(),
                                      arguments: {"userId": user.id},
                                      binding: BindingsBuilder(() {
                                        Get.put<PointsController>(
                                            PointsController());
                                      }),
                                    );
                                  },
                                  title: "Your credits",
                                  leading: Icons.credit_score_outlined,
                                ),
                              ],
                            ),
                          ),
                          const AppDivider(),
                          //shopping address
                          Container(
                            height: 140.h,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                TilesWidget(
                                  onTap: () {
                                    Get.toNamed(RouteNames.getAddresses());
                                  },
                                  title: "Shipping addresses",
                                  leading: SimpleLineIcons.location_pin,
                                ),
                                TilesWidget(
                                  onTap: () {
                                    customerService(context, serviceNumber);
                                  },
                                  title: "Service Center",
                                  leading: AntDesign.customerservice,
                                ),
                                TilesWidget(
                                  title: "App Feedback",
                                  leading: MaterialIcons.rss_feed,
                                  onTap: () {
                                    if (!kIsWeb) {
                                      ShowDialogue().showDialog(
                                          title: "Feedback",
                                          middleText:
                                              "For providing feedback, download the app.\nIf you need to provide feedback about products\nYou may do chat from product page on the web app.");
                                    } else {
                                      BetterFeedback.of(context)
                                          .show((UserFeedback feedback) async {
                                        var url = feedback.screenshot;
                                        if (kIsWeb) {
// // // // START_DISABLE
// upload.feedbackHtml.value =
// await upload
// .handleScreenshotForWeb(
// url, "feedback");
// String message = feedback.text;
// await upload.uploadImageToFirebaseWeb(
// upload.feedbackHtml.value!,
// message);
// // // // END_DISABLE
                                        } else {
                                          upload.feedbackFile.value =
                                              await upload
                                                  .handleScreenshotForMobile(
                                                      url, "feedback");
                                          String message = feedback.text;
                                          upload.uploadImageToFirebaseMobile(
                                              message);
                                        }
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          const AppDivider(),
                          //chats
                          Container(
                            height: 150.h,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                TilesWidget(
                                  onTap: () {
                                    Get.toNamed(RouteNames.getChatListRoute());
                                  },
                                  title: "Chats",
                                  leading: SimpleLineIcons.speech,
                                ),
                                TilesWidget(
                                  onTap: () {
                                    Get.toNamed(RouteNames.getSettings());
                                  },
                                  title: "Settings",
                                  leading: SimpleLineIcons.settings,
                                ),
                                TilesWidget(
                                  onTap: () {
                                    // Your existing onTap logic
                                    Get.toNamed(RouteNames.getAppVersionPage());
                                  },
                                  title:
                                      "App version ${setUpController.appVersion}",
                                  // Use pre-fetched version
                                  leading: AntDesign.iconfontdesktop,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          );
  }
}
