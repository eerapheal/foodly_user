import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/show_dialogue_app.dart';
import 'package:foodly_user/common/show_snack_bar.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/login_controller.dart';
import 'package:foodly_user/models/login_request.dart';
import 'package:foodly_user/views/auth/registration.dart';
import 'package:foodly_user/views/auth/widgets/email_textfield.dart';
import 'package:foodly_user/views/auth/widgets/password_field.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> with TickerProviderStateMixin {
  late final TextEditingController _rePasswordController = TextEditingController();
  late final TextEditingController _passwordController =
  TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _rePasswordFocusNode = FocusNode();

  bool validateAndResetPassword() {
    String password = _passwordController.text.trim();
    String rePassword = _rePasswordController.text.trim();

    // Basic validation
    if (password.isEmpty || rePassword.isEmpty) {
      showCustomSnackBar("Both fields are required.", title: "Reset Password");
      return false;
    }
    if (password != rePassword) {
      showCustomSnackBar("Passwords don't match.", title: "Reset Password");
      return false;
    }

    // Password strength validation (minimum 8 characters, at least 1 number)
    if (password.length < 8 || !RegExp(r'\d').hasMatch(password)) {
      showCustomSnackBar(
        "Password must be at least 8 characters long and include a number.",
        title: "Reset Password",
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _rePasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Container(
      color: kWhite,
      margin: EdgeInsets.symmetric(horizontal: padding),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: CommonBackButton(),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Container(
                  width: width,
                  height: hieght / 2.5, // Adjusted height to avoid gray area
                  color: kWhite, // Match the background color
                  child: LottieBuilder.asset(
                    "assets/anime/delivery.json",
                    width: width,
                    height: hieght / 2.5, // Adjusted to avoid stretching
                  ),
                ),
                Column(
                  children: [
                    //email

                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenButtonWidth(300),
                        // Minimum width for the button
                        maxWidth: screenButtonWidth(
                            450), // Maximum width or fallback
                      ),

                      child: SizedBox(
                        width: kIsWeb ? 350 : (width - 40.w),
                        height: screenButtonHeight(70),
                        child: PasswordField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenButtonWidth(300),
                        // Minimum width for the button
                        maxWidth: screenButtonWidth(
                            450), // Maximum width or fallback
                      ),

                      child: SizedBox(
                        width: kIsWeb ? 350 : (width - 40.w),
                        height: screenButtonHeight(70),
                        child: PasswordField(
                          controller: _rePasswordController,
                          focusNode: _rePasswordFocusNode,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 6.h,
                    ),


                    Obx(() => controller.isLoading
                        ? const Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: kPrimary,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(kLightWhite),
                        ))
                        : ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenButtonWidth(300),
                        // Minimum width for the button
                        maxWidth: screenButtonWidth(
                            450), // Maximum width or fallback
                      ),
                      child: CustomButton(
                          btnHieght: screenButtonHeight(70),
                          btnWidth: kIsWeb ? 350 : (width - 40.w),
                          color: kPrimary,
                          text: "R E S E T",
                          radius: 10,
                          onTap: () {

                             if( validateAndResetPassword()){
                               ResetPasswordRequest model = ResetPasswordRequest(

                                 password: _rePasswordController.text,
                                 rePassword: _passwordController.text,);
                               String authData = resetPasswordRequestToJson(model);
                               controller.resetPassword(authData, model);
                             }


                          }),
                    )),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}


