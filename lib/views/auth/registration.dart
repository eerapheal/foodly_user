import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/registration_controller.dart';
import 'package:foodly_user/models/registration.dart';
import 'package:foodly_user/views/auth/widgets/email_textfield.dart';
import 'package:foodly_user/views/auth/widgets/password_field.dart';
import 'package:foodly_user/views/home/widgets/custom_btn.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final TextEditingController _usernameController =
      TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool validateAndSave() {
    final form = _loginFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegistrationController());
    return Container(
      color: kWhite,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: CommonBackButton(),

        ),
        body: ListView(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _loginFormKey,
                child:
                  Column(
                    children: [
                      //email

                      ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: screenButtonWidth(300),
                            // Minimum width for the button
                            maxWidth: screenButtonWidth(
                                600), // Maximum width or fallback
                          ),
                          child: SizedBox(
                              width: kIsWeb ? 350 : (width - 40.w),
                              child: EmailTextField(
                                focusNode: _passwordFocusNode,
                                hintText: "Username",
                                controller: _usernameController,
                                prefixIcon: Icon(
                                  CupertinoIcons.person,
                                  color: Theme.of(context).dividerColor,
                                  size: 20.h,
                                ),
                                keyboardType: TextInputType.text,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode),
                              ))),

                      SizedBox(
                        height: 15.h,
                      ),
                      ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: screenButtonWidth(300),
                            // Minimum width for the button
                            maxWidth: screenButtonWidth(
                                600), // Maximum width or fallback
                          ),
                          child: SizedBox(
                              width: kIsWeb ? 350 : (width - 40.w),
                              child: EmailTextField(
                                focusNode: _passwordFocusNode,
                                hintText: "Email",
                                controller: _emailController,
                                prefixIcon: Icon(
                                  CupertinoIcons.mail,
                                  color: Theme.of(context).dividerColor,
                                  size: 20.h,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode),
                              ))),

                      SizedBox(
                        height: 15.h,
                      ),
                      ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: screenButtonWidth(300),
                            // Minimum width for the button
                            maxWidth: screenButtonWidth(
                                600), // Maximum width or fallback
                          ),
                          child: SizedBox(
                              width: kIsWeb ? 350 : (width - 40.w),
                              child: PasswordField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                              ))),

                      SizedBox(
                        height: 6.h,
                      ),

                      SizedBox(
                        height: 12.h,
                      ),

                      Obx(
                        () => controller.isLoading
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
                                      600), // Maximum width or fallback
                                ),

                                child: CustomButton(
                                    btnHieght: screenButtonHeight(70),
                                    btnWidth: kIsWeb ? 350 : (width - 40.w),
                                    color: kPrimary,
                                    radius: appBorderRadius,
                                    text: "R E G I S T E R",
                                    onTap: () {
                                      Registration model = Registration(
                                          username: _usernameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text);

                                      String userdata =
                                          registrationToJson(model);

                                      controller.registration(userdata);
                                    })),
                      )
                    ],
                  ),

              ),
            )
          ],
        ),
      ),
    );
  }
}
