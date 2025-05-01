import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/cached_image_loader.dart';
import 'package:foodly_user/common/reusable_text.dart';
import 'package:foodly_user/common/show_dialogue_app.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/address_controller.dart';
import 'package:foodly_user/controllers/location_controller.dart';
import 'package:foodly_user/hooks/fetchDefaultAddress.dart';
import 'package:foodly_user/views/orders/widgets/updates.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class CustomAppBar extends StatefulHookWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final box = GetStorage();
  LatLng _center = const LatLng(37.78792117665919, -122.41325651079953);

  Future<void> _getCurrentLocation() async {
    final location = Get.put(UserLocationController());

    location.setUserLocation(_center); // Set initial user location
    var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    if (!mounted) return;

    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      location.getAddressFromLatLng(_center); // Get the address from LatLng
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      box.write('userLat', 37.78792117665919);
      box.write('userLng', -122.41325651079953);
      Get.find<UserLocationController>().reloadItems=1;
      ShowDialogue().showDialog(
        title: "Location denied",
        middleText: "Since you denied the location,\nYou need to manually activate it.\nOtherwise you will see products far\nfrom your current location",
      );

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        box.write('userLat', 37.78792117665919);
        box.write('userLng', -122.41325651079953);
        Get.find<UserLocationController>().reloadItems=1;
        ShowDialogue().showDialog(
          title: "Location denied",
          middleText: "Since you denied the location,\nYou need to manually activate it.\nOtherwise you will see products far\nfrom your current location",
        );
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      box.write('userLat', 37.78792117665919);
      box.write('userLng', -122.41325651079953);
      Get.find<UserLocationController>().reloadItems=1;
      ShowDialogue().showDialog(
        title: "Location denied",
        middleText: "Since you denied the location,\nYou need to manually activate it.\nOtherwise you will see products far\nfrom your current location",
      );
      return Future.error('Location permissions are permanently denied');
    }

    _getCurrentLocation();
  }
  String? accessToken;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    accessToken = box.read("token");
    _determinePosition(); // Call this to determine and set the location
  }

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<UserLocationController>(); // Get the controller instance
    final controller = Get.put(AddressController());

    if (accessToken != null) {
      useFetchDefault(context, false); // Ensure this is necessary
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 6.h),
      constraints: BoxConstraints(minHeight: 70.h),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: /*CachedImageLoader(
                          imageWidth: screenButtonWidth(50),
                          imageHeight: screenButtonHeight(kIsWeb ? 60 : 50),
                          image: profile,
                          fit: BoxFit.contain,
                        )*/Image.network(
                          width: screenButtonWidth(50),
                          height: screenButtonHeight(kIsWeb ? 60 : 50),
                          profile,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ReusableText(
                              text: "Delivering to",
                              style: appStyle(screenFontSize(kFontSizeSmall), kSecondary, FontWeight.w600),
                            ),
                            Obx(() {
                              final address = locationController.userLocation.value.address.value;

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  address.isNotEmpty
                                      ? controller.defaultAddress == null
                                      ? address
                                      : controller.defaultAddress!.addressLine1
                                      : "San Francisco 1 Stockton Street",
                                  overflow: TextOverflow.ellipsis,
                                  style: appStyle(11, kGray, FontWeight.normal),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  getTimeOfDay(),
                  style: const TextStyle(fontSize: 35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getTimeOfDay() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return "☀️";
    } else if (hour >= 12 && hour < 17) {
      return "🌤️";
    } else {
      return "🌙";
    }
  }

  String profile =
      "https://firebasestorage.googleapis.com/v0/b/flutter-foodly-final-7d6ce.appspot.com/o/foodly_categories%2Fprofile.png?alt=media&token=82ad8851-de87-42d1-8e5b-632a900eb866";
}
