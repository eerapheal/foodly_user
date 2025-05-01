import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/back_ground_container.dart';
import 'package:foodly_user/common/custom_container.dart';
import 'package:foodly_user/common/divida.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/notifications_controller.dart';
import 'package:foodly_user/controllers/order_controller.dart';
import 'package:foodly_user/controllers/tab_controller.dart';
import 'package:foodly_user/views/entrypoint.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:foodly_user/views/orders/widgets/order_page_tile.dart';
import 'package:foodly_user/views/restaurant/restaurants_page.dart';
import 'package:get/get.dart';

import '../../models/order_details.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());
    final message =
    ModalRoute.of(context)?.settings.arguments as NotificationResponse?;
    var orderData;

    // Fallback logic
    if (message != null && message.payload != null) {
      // If we came from a notification, use the payload to get the orderId
      orderData = jsonDecode(message.payload.toString());
      controller.getOrder(orderData['orderId']);
    } else if (orderId != null) {
      // If we came from navigation, use the passed orderId to fetch the order
      controller.getOrder(orderId!);
    } else {
      // Handle the case when neither the orderId nor the notification payload is available
      return const Scaffold(
        body: Center(
          child: Text("Order ID not available"),
        ),
      );
    }

    //print(" notifications page payload ${message.payload}");
    return Obx(() => Container(
      color: kOffWhite,
      padding:  EdgeInsets.symmetric(horizontal: padding),
      child: Scaffold(
        backgroundColor: kOffWhite,
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){
              Get.find<MainScreenController>().setTabIndex=0;
              Get.offAll(()=>MainScreen());

            }, icon: Icon(Icons.home))
          ],
          backgroundColor:kOffWhite,
          elevation: 0,
          centerTitle: true,
          leading: const CommonBackButton(icon: Ionicons.chevron_back_circle,),
          title: ReusableText(
              text: 'Order details page',
              style: appStyle(16, kGray, FontWeight.w600)),
        ),
        body: controller.loading == true
            ? const FoodsListShimmer()
            : CustomContainer(

          containerContent: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                Container(
                  width: width,
                  height: hieght * (kIsWeb? 0.22:0.20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    margin: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 0),
                    decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(12.r)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            ReusableText(
                                text:
                                controller.order!.restaurantId.title,
                                style:
                                appStyle(20, kGray, FontWeight.bold)),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: kTertiary,
                              backgroundImage: NetworkImage(
                                  controller.order!.restaurantId.logoUrl),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        RowText(
                            first: "Business Hours",
                            second: controller.order!.restaurantId.time),
                        SizedBox(
                          height: 5.h,
                        ),
                        const Divida(),
                        SizedBox(
                          height: 5.h,
                        ),
                        Table(
                          children: [
                            TableRow(children: [
                              ReusableText(
                                  text: "Recipient",
                                  style: appStyle(
                                      11, kGray, FontWeight.w600)),
                              ReusableText(
                                  text: controller.order!.deliveryAddress
                                      .addressLine1,
                                  style: appStyle(
                                      11, kGray, FontWeight.normal)),
                            ]),
                            TableRow(children: [
                              ReusableText(
                                  text: "Restaurant",
                                  style: appStyle(
                                      11, kGray, FontWeight.w600)),
                              ReusableText(
                                  text: controller
                                      .order!.restaurantId.coords.address,
                                  style: appStyle(
                                      11, kGray, FontWeight.normal)),
                            ]),
                            TableRow(children: [
                              ReusableText(
                                  text: "Order Number",
                                  style: appStyle(
                                      11, kGray, FontWeight.w600)),
                              ReusableText(
                                  text: controller.order!.id,
                                  style: appStyle(
                                      11, kGray, FontWeight.normal)),
                            ]),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 100*controller.order!.orderItems.length.toDouble(),
                  child: ListView.builder(
                    itemCount: controller.order!.orderItems.length,
                    itemBuilder: (context, index) {
                      OrderItem item =
                      controller.order!.orderItems[index];
                      return SizedBox(
                        height: 90,
                        child: OrderPageTile(
                          food: item,
                          status: controller.order!.orderStatus,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                //controller.order!.orderStatus=="Delivered"? the first
                //to prevent crash the one doesnot have the status.
                controller.order!.orderStatus=="Delivered"?
                Obx((){
                return  controller.order!.orderStatus=="Delivered"?
                  Container(

                    padding: EdgeInsets.symmetric(horizontal: 12.h),
                    child: GestureDetector(
                      onTap: () async {
                        if(controller.order!.confirmation==true) {
                          //already confirmed
                        }else{

                          Get.find<OrderController>().confirmation.value =  await  Get.find<OrderController>().updateConfirmation(controller.order!.id);
                          if(Get.find<OrderController>().confirmation.value==true){
                            Get.find<OrderController>().setLoading=false;
                          }
                        }
                      },
                      child:Get.find<OrderController>().isLoading==false? CustomButton(
                          btnHieght: 40.h,
                          text: (Get.find<OrderController>().confirmation.value==true||controller.order!.confirmation==true)?"Already confirmed":"Confirm"
                      ):SizedBox(),
                    ),
                  ):Container();
                }):Container()
                //  controller.order!.orderStatus == 'Out_for_Delivery' ?
                // Container(
                //  // padding: EdgeInsets.symmetric(horizontal: 9.w),
                //      margin: EdgeInsets.fromLTRB(8.w, 0.w, 8.w, 0),
                //      decoration: BoxDecoration(
                //          color: kSecondaryLight,
                //          borderRadius: BorderRadius.circular(30.r)),
                //  child: Row(
                //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //    children: [
                //       CircleAvatar(
                //                radius: 16,
                //                backgroundColor: kTertiary,
                //                backgroundImage:
                //                    NetworkImage(controller.order!.driverId!.driver.profile),
                //              ),
                //      Padding(
                //        padding: const EdgeInsets.all(8.0),
                //        child: Row(
                //          mainAxisAlignment: MainAxisAlignment.center,
                //          crossAxisAlignment: CrossAxisAlignment.center,
                //          children: [
                //            const Icon(SimpleLineIcons.screen_smartphone, color: kGray, size: 14),
                //
                //            SizedBox(width: 5.w,),
                //            ReusableText(text: items.driverId!.driver.phone, style: appStyle(13, kGray, FontWeight.w400)),
                //          ],
                //        ),
                //      ),
                //    ],
                //  ),
                // ): const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
