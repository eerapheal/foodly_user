// // // // START_DISABLE
// import 'dart:html' as html;
// // // // END_DISABLE
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TitleMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    print("TitleMiddleware: onPageCalled triggered");

    // Access the route's parameters
    final parameters = page?.parameters ?? {};
    print("Parameters: $parameters");

    // Update the document title
// // // // // // // // // // // // // // START_DISABLE
// final name = parameters['name'] ?? 'Food';
// html.document.title = '$name - Foodly';
// print("my title ${html.document.title}");
// // // // // // // // // // // // // // END_DISABLE
    return super.onPageCalled(page);
  }
}
