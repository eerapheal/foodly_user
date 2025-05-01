import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/password_controller.dart';
import 'package:get/get.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    Key? key,
    required this.controller,
    this.focusNode,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    final passwordController = Get.put(PasswordController());
    return Obx(() => SizedBox(
      width: screenTextBoxWidth(),
      height: screenButtonHeight(50),
      child: TextFormField(
        cursorColor: Colors.black,
        textInputAction: TextInputAction.next,
        focusNode: focusNode,
        keyboardType: TextInputType.visiblePassword,
        controller: controller,
        obscureText: passwordController.password,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter a valid password";
          } else {
            return null;
          }
        },
        style: appStyle(screenFontSize(12), kDark, FontWeight.normal),
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              passwordController.setPassword =
              !passwordController.password;
            },
            child: Icon(
              passwordController.password
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: kGrayLight,
            ),
          ),
          hintText: 'Password ',
          prefixIcon:  Icon(
            CupertinoIcons.lock_circle,
            color: kGrayLight,
            size: 26.h,
          ),
          isDense: true,
          contentPadding:  EdgeInsets.all(screenPad(6)),
          hintStyle: appStyle(screenFontSize(12), kGray, FontWeight.normal),
          // contentPadding: EdgeInsets.only(left: 24),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedBorder: const OutlineInputBorder(
              borderSide:
              BorderSide(color: kPrimary, width: 0.5),
              borderRadius:  BorderRadius.all(Radius.circular(10))),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kRed, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kGray, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kGray, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          border: const OutlineInputBorder(
            borderSide:
            BorderSide(color: kPrimary, width: 0.5),
            borderRadius:  BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    )
      );
    
  }
}