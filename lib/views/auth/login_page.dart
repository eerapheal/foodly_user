import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/app_style.dart';
import 'package:foodly_user/common/show_dialogue_app.dart';
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

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final controller = Get.find<LoginController>();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_){
      ShowDialogue().showDialog(
          title: "Test account",
          middleText:"Email: info@dbestech.com\n Password: 12345678"
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


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
                        height: screenButtonHeight(50),
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
                      ),
                    )),
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
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 6.h,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const RegistrationPage());
                            },

                            child: Text('Register',
                                style: appStyle(
                                    screenFontSize(kFontSizeLarge), Colors.black, FontWeight.normal)),
                          ),

                        ],
                      ),
                    ),

                    SizedBox(
                      height: 15.h,
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
                                text: "L O G I N",
                                radius: 10,
                                onTap: () {

                                  LoginRequest model = LoginRequest(
                                      email: _emailController.text,
                                      password: _passwordController.text);

                                  String authData = loginRequestToJson(model);

                                  controller.loginFunc(authData, model);
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
