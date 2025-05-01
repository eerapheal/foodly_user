import 'package:flutter/cupertino.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/views/entrypoint.dart';
import 'package:get/get.dart';

class AppGetHome {
  void appGetHome() {
    Get.offUntil(
      GetPageRoute(
        settings: RouteSettings(name: RouteNames.getMainScreenRoute()),
        page: () => MainScreen(), // Replace with your main screen widget
      ),
      (route) => false, // Removes all routes
    );
  }
}
