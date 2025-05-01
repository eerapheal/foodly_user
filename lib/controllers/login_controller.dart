// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_user/common/entities/user.dart';
import 'package:foodly_user/common/services/services.dart';
import 'package:foodly_user/common/show_dialogue_app.dart';
import 'package:foodly_user/common/show_snack_bar.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/controllers/app_setup_controller.dart';
import 'package:foodly_user/controllers/notifications_controller.dart';
import 'package:foodly_user/controllers/reload_controllers.dart';
import 'package:foodly_user/controllers/tab_controller.dart';
import 'package:foodly_user/models/api_error.dart';
import 'package:foodly_user/models/environment.dart';
import 'package:foodly_user/models/login_request.dart';
import 'package:foodly_user/models/login_response.dart';
import 'package:foodly_user/views/auth/verification_page.dart';
import 'package:foodly_user/views/entrypoint.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final controller = Get.put(NotificationsController());
  final box = GetStorage();
  RxBool _isLoading = false.obs;
  final db = FirebaseFirestore.instance;
  bool get isLoading => _isLoading.value;
  LoginResponse? _loginResponse;
  LoginResponse? get loginResponse => _loginResponse;
  set setLoading(bool newValue) {
    _isLoading.value = newValue;
  }

  void resetPassword(String model, ResetPasswordRequest resetRequest) async {

    setLoading = true;
    final box =  GetStorage();
    String? token = box.read('token');
    String accessToken = jsonDecode(token!);

    String email = box.read("userEmail");
    email = jsonDecode(email);
    print("email $email");
    if(email=="info@dbestech.com"){
      ShowDialogue().showDialog(
        title: "Test account",
        middleText: "You can not change the password of this account since this is a test account"
      );
      setLoading = false;
      //showCustomSnackBar("You can not change the password of this account", title: "Test account", isError: false);
      return;
    }

    var url = Uri.parse('${Environment.appBaseUrl}/resetPassword');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: model,
      );
      if (response.statusCode == 200) {
       // ResetPasswordRequest data = resetPasswordRequestFromJson(response.body);

        setLoading = false;
        showCustomSnackBar("Check your email to find the verification code", title: "Verification code",isError: false);
        logout();

      } else {
        var data = apiErrorFromJson(response.body);
        showCustomSnackBar(data.message, title: "Failed to login, please try again");
        print("data is $data");
        print("status is ${response.statusCode}");
      }
    } catch (e) {
      setLoading = false;

      showCustomSnackBar(e.toString(), title: "Failed to login, please try again");

    } finally {
      setLoading = false;
    }
  }

  void loginFunc(String model, LoginRequest login) async {
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/login');

    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: model,
      );
      if (response.statusCode == 200) {
        LoginResponse data = loginResponseFromJson(response.body);
        String userId = data.id;
        String userData = json.encode(data);
        box.write(userId, userData);
        box.write("user", userData);
        box.write("token", json.encode(data.userToken));
        box.write("userId", json.encode(data.id));
        box.write("userEmail", json.encode(data.email));
        box.write("verification", data.verification);

        if (data.phoneVerification == true) {
          box.write("phone_verification", true);
        } else {
          box.write("phone_verification", false);
        }

        setLoading = false;
        controller.updateUserToken(controller.fcmToken);
        Get.snackbar("Successfully logged in ", "Enjoy your awesome experience",
            colorText: kLightWhite,
            backgroundColor: kPrimary,
            icon: const Icon(Ionicons.fast_food_outline));

        final responseAddress = await http.get(
          Uri.parse('${Environment.appBaseUrl}/api/address/default'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${data.userToken}',
          },
        );

        if (responseAddress.statusCode == 200) {
          var data = jsonDecode(responseAddress.body);

          final double lat = data['latitude'];
          final double lng = data['longitude'];

          // Save latitude and longitude to GetStorage
          box.write('userLat', lat);
          box.write('userLng', lng);

        }
        Get.find<ReloadController>().clearCache();
        var userbase = await db.collection("users").withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options)=>userdata.toFirestore(),
        ).where("id", isEqualTo: userId).get();

        if(userbase.docs.isEmpty){
          print("docs---empty");
          final data = UserData(
              id:userId,
              name: "",
              email: login.email,
              photourl: "",
              location: "",
              fcmtoken: "",
              addtime: Timestamp.now()

          );
           try {
            await db.collection("users").withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userdata, options) => userdata.toFirestore(),
            ).add(data);

            print("docs---updated");
          } catch (e) {
            print("Error adding document: $e");
          }
          print("docs---updated");
        }else{
          print("docs---exist");
        }

        if (data.verification == false) {
          Get.offAll(() => const VerificationPage(),
              transition: Transition.fade,
              duration: const Duration(seconds: 2));
        } else {
          Get.offUntil(
            GetPageRoute(
              settings: RouteSettings(name: RouteNames.getMainScreenRoute()),
              page: () => MainScreen(), // Replace with your main screen widget
            ),
                (route) => false, // Removes all routes
          );
        }
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to login, please try again",
            colorText: kLightWhite,
            backgroundColor: kRed,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to login, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }

  void logout() {
    box.erase();
    Get.toNamed(RouteNames.getMainScreenRoute());
    Get.find<MainScreenController>().setTabIndex=0;
  }

  bool userLogged(){
    final String? token = box.read("token");
    if(token==null) return false;
    return true;
  }

  LoginResponse? getUserData() {
    String? userId = box.read("userId");
    String? data = box.read(jsonDecode(userId!));
    if (data != null) {
      return loginResponseFromJson(data);
    }
    return null;
  }

  void deleteAccount() async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/api/users');

    try {
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        setLoading = false;
        box.erase();
        Get.offAll(() => MainScreen(),
            transition: Transition.fade, duration: const Duration(seconds: 2));
      } else {
        var data = apiErrorFromJson(response.body);

        Get.snackbar(data.message, "Failed to delete, please try again",
            backgroundColor: kRed,
            snackPosition: SnackPosition.BOTTOM,
            icon: const Icon(Icons.error));
      }
    } catch (e) {
      setLoading = false;

      Get.snackbar(e.toString(), "Failed to delete, please try again",
          colorText: kLightWhite,
          backgroundColor: kRed,
          icon: const Icon(Icons.error));
    } finally {
      setLoading = false;
    }
  }
}
