import 'package:flutter/cupertino.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/login_controller.dart';
import 'package:get/get.dart';
import 'package:foodly_user/views/auth/login_page.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if user is logged in
    final isLoggedIn = Get.find<LoginController>().userLogged();

    // If not logged in, redirect to login page
    if (!isLoggedIn) {
      return const RouteSettings(name: RouteNames.signIn);
    }
    return null; // Allow navigation if logged in
  }
}
