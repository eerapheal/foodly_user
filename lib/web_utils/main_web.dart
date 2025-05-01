//Enable to the below for web app
// // // // // // // START_DISABLE
// import 'dart:html' as html;
// 
// // // // // // END_DISABLE
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:get/get.dart';

// // // // START_DISABLE
// void webRedirectAfterPayment() {
// if (kIsWeb) {
// final uriFragment = getUriFragment();
// 
// if (uriFragment.isNotEmpty) {
// final uri = Uri.parse(uriFragment.replaceFirst('#', ''));
// final status = uri.queryParameters['status'];
// final page = uri.queryParameters['page'];
// if (status == 'success' && page == 'orderDetails') {
// WidgetsBinding.instance.addPostFrameCallback((_) {
// Get.toNamed("/checkout-success-web");
// Get.toNamed(RouteNames.orderSuccessWeb);
// });
// }
// }
// }
// }
// // // // END_DISABLE

// // // // START_DISABLE
// String getUriFragment() {
// return html.window.location.hash;
// }
// // // // END_DISABLE

void showWebPopUp(String message) {
  if (kIsWeb) {
    showWebPopUp(message);
  }
}
// // // // // // // // END_DISABLE

/*
void webRedirectAfterPayment() {
 if(kIsWeb){
   // Check the initial URL query parameters
   // Get full URL from window location
   // Extract and parse the fragment part after '#'
   final uriFragment = html.window.location.hash;
   print("URI Fragment: $uriFragment");


   // Remove the leading '#' from the fragment and parse as query parameters
   final uri = Uri.parse(uriFragment.replaceFirst('#', ''));

   final status = uri.queryParameters['status'];
   final page = uri.queryParameters['page'];


   if (status == 'success' && page == 'orderDetails') {
     WidgetsBinding.instance.addPostFrameCallback((_) {
       //Get.offAll(() => Successful());
       Get.toNamed("/checkout-success");
     });
   }
 }
}

void showWebPopUp(String message) {
  html.window.alert(message); // This will display the native browser alert
}*/
