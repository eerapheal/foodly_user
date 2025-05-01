
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/custom_container.dart';
import 'package:foodly_user/common/global_network_message.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/shimmers/foodlist_shimmer.dart';
import 'package:foodly_user/common/utils/cart_bottom_sheet.dart';
import 'package:foodly_user/common/utils/global_loading.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/order_controller.dart';
import 'package:foodly_user/hooks/fetchCart.dart';
import 'package:foodly_user/models/user_cart.dart';
import 'package:foodly_user/views/cart/widgets/cart_tile.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:foodly_user/controllers/check_out_controller.dart';

class CartPage extends HookWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read('token');
    final hookResult = useFetchCart();
    final items = hookResult.data;
    final isLoading = hookResult.isLoading;
    UserCart userCart;
    CartCheckoutController checkoutController =
        Get.find<CartCheckoutController>();

    if (token == null) {
      return Container(
        color: kWhite,
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Scaffold(
          backgroundColor: kWhite,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(height: screenButtonHeight(hieght-200),"assets/images/empty_cart.png"),
                CustomButton(
                    btnHieght: screenButtonHeight(70),
                    btnWidth: kIsWeb ? 350 : (width - 40.w),
                    color: kPrimary,
                    radius: appBorderRadius,
                    text: "Browse item first",
                    onTap: () {
                      Get.toNamed(RouteNames.getSignInRoute());
                    })
              ],
            ),
          ),
        ),
      );
    }
    if(isLoading){
      return Center(
        child: Stack(
          children: [

            GlobalLoading()
          ],
        ),
      );
    }else if (items.length == 0 || items == null) {
      if(items.length==0){
        return Container(
          color: kWhite,
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Scaffold(
            backgroundColor: kWhite,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(height: screenButtonHeight(hieght-200),"assets/images/empty_cart.png"),
                  CustomButton(
                      btnHieght: screenButtonHeight(70),
                      btnWidth: kIsWeb ? 350 : (width - 40.w),
                      color: kPrimary,
                      radius: appBorderRadius,
                      text: "Browse item first",
                      onTap: () {
                        Get.toNamed(RouteNames.getSignInRoute());
                      })
                ],
              ),
            ),
          ),
        );
      }else{

        return Container(
          color: kWhite,
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Scaffold(
            backgroundColor: kWhite,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(height: screenButtonHeight(hieght-200),"assets/images/empty_cart.png"),
                  CustomButton(
                      btnHieght: screenButtonHeight(70),
                      btnWidth: kIsWeb ? 350 : (width - 40.w),
                      color: kPrimary,
                      radius: appBorderRadius,
                      text: "Browse item first",
                      onTap: () {
                        Get.toNamed(RouteNames.getSignInRoute());
                      })
                ],
              ),
            ),
          ),
        );

      }
    }else if(items.length>0){
      WidgetsBinding.instance.addPostFrameCallback((_){
        checkoutController.cartObs.assignAll(items);
      });

    }else{
      return Container();
    }


    return  Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      color: kWhite,
      child: Scaffold(
              backgroundColor: kWhite,
              appBar: AppBar(
                backgroundColor:kWhite,
                title:  Center(
                  child: ReusableText(
                    text: "Family Cart",
                    style: appStyle(16, kGray, FontWeight.w600),
                  ),
                ),
                automaticallyImplyLeading: false,
                elevation: 0,
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: CustomContainer(
                    color: Colors.transparent,
                      containerContent: Column(
                    children: [
                      isLoading
                          ? const FoodsListShimmer()
                          : Obx(()=>Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                        width: width,
                        height: hieght,
                        color: kLightWhite,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: checkoutController.cartObs.length,
                          itemBuilder: (context, i) {
                            userCart = checkoutController.cartObs[i];
                            box.write("cart", items.length.toString());

                            return CartTile(
                              item: userCart,
                              itemId: i,
                            );
                          },
                        ),
                      )),
                    ],
                  )),
                ),
              ),
              bottomNavigationBar: Container(
                //padding:  EdgeInsets.symmetric(horizontal: padding),
                child: Obx(() {
                  if (checkoutController.cartItems.isNotEmpty) {
                    return GestureDetector(
                      onTap: () {

                        if(checkoutController.restList.isNotEmpty){
                          final controller = Get.put(OrderController());
                          showCartPaymentMethodsBottomSheet(context, );
                          Get.find<OrderController>().orderPrice= checkoutController.totalPrice.toDouble();
                        }else{

                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 70, top: 10),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          height: 40.h,
                          width: width,
                          decoration: BoxDecoration(
                            color: kSecondary,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.r),
                            ),
                          ),
                          child: Center(
                            child: ReusableText(
                                    text:
                                        "CHECKOUT   \$${checkoutController.totalPrice.toStringAsFixed(2)}",
                                    style:
                                        appStyle(16, kLightWhite, FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                    );
                  } else{
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 70, top: 10),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        height: 40.h,
                        width: width,
                        decoration: BoxDecoration(
                          color: kSecondary,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.r),
                          ),
                        ),
                        child: Center(
                          child: ReusableText(
                            text:
                            "Tap on the items to cart",
                            style:
                            appStyle(16, kLightWhite, FontWeight.bold),
                          ),
                        ),
                      ),
                    );}
                }),
              )),
    );
  }
}
