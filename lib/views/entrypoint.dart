import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/tab_controller.dart';
import 'package:foodly_user/hooks/fetchDefaultAddress.dart';
import 'package:foodly_user/views/cart/cart_page.dart';
import 'package:foodly_user/views/home/home_page.dart';
import 'package:foodly_user/views/profile/profile_page.dart';
import 'package:foodly_user/views/search/seach_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore: must_be_immutable
class MainScreen extends HookWidget {
  MainScreen({Key? key}) : super(key: key);

  final box = GetStorage();

  List<Widget> pageList = <Widget>[
    HomePage(),
    const SearchPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read('token');
    bool? verification = box.read("verification");

    // Check verification status and use fetch if needed
    if (token != null && verification == false) {
      // Handle verification logic here
    } else if (token != null && verification == true) {
      useFetchDefault(context, true);
    }

    final entryController = Get.put(MainScreenController());

    return Obx(() => Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
         // toolbarHeight: kToolbarHeight - 10,
        automaticallyImplyLeading:false ,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding) ,// Set your desired width here
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Foodly Family', style: TextStyle(
                color: Color(0xFF30b9b2)
              ),),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    iconSize: screenIconSize(20),
                    alignment: Alignment.centerRight,
                    icon: const Icon(AntDesign.appstore1, color: kMenu, ),
                    onPressed: () {
                      entryController.setTabIndex = 0; // Navigate to Home
                    },
                  ),
                  IconButton(
                    iconSize: screenIconSize(20),
                    alignment: Alignment.centerRight,
                    icon: const Icon(Ionicons.search, color: kMenu,),
                    onPressed: () {
                      entryController.setTabIndex = 1; // Navigate to Search
                    },
                  ),
                  IconButton(
                    iconSize: screenIconSize(20),

                    alignment: Alignment.centerRight,
                    icon: const Icon(FontAwesome.opencart, color: kMenu,),
                    onPressed: () {
                      entryController.setTabIndex = 2; // Navigate to Cart
                    },
                  ),

                  IconButton(
                    iconSize: screenIconSize(20),

                    padding: EdgeInsets.only(right: 0),
                    alignment: Alignment.centerRight,
                    icon: const Icon(
                      FontAwesome.user_circle_o,
                      color: kMenu,),
                    onPressed: () {
                      entryController.setTabIndex = 3; // Navigate to Profile
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: pageList[entryController.tabIndex],
    ));
  }
}


