import 'package:flutter/material.dart';
import 'package:foodly_user/common/utils/app_get_home.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/tab_controller.dart';
import 'package:foodly_user/views/entrypoint.dart';
import 'package:get/get.dart';
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, this.text="Not found page", this.crash});
  final String text;
  final bool? crash;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhite,
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          backgroundColor: kWhite,
          leading: const CommonBackButton(),

          centerTitle: true,
          actions: [
            IconButton(onPressed: (){
              Get.find<MainScreenController>().setTabIndex=0;
              AppGetHome().appGetHome();

            }, icon: const Icon(Icons.home))
          ],
          title: const Text('Page Not Found', style: TextStyle(),),
        ),

        body: Center(
          child: Image.asset(height: screenButtonHeight(hieght-200),"assets/images/404_error.png"),
        ),
      ),
    );
  }
}
