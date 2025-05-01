import 'dart:convert';
import 'package:foodly_user/services/api_services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodly_user/models/environment.dart';
import 'package:foodly_user/models/login_response.dart';
import 'package:foodly_user/models/api_error.dart';

import '../common/entities/user.dart';
import '../models/login_request.dart';

class LoginService extends ApiService{
  final GetStorage box = GetStorage();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Login function that makes a POST request and stores user data
  Future<LoginResponse?> login(String model, LoginRequest login) async {
    var url = Uri.parse('${Environment.appBaseUrl}/login');

    var response = await makeHttpRequest('GET', url, headers: getAuthHeaders());

    /*
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: model,
      );*/

      if (response["status"] == 200) {
        LoginResponse data = loginResponseFromJson(response["data"]);
        String userId = data.id;
        String userData = json.encode(data);

        // Store user details in GetStorage
        box.write(userId, userData);
        box.write("user", userData);
        box.write("token", json.encode(data.userToken));
        box.write("userId", json.encode(data.id));
        box.write("userEmail", json.encode(data.email));
        box.write("verification", data.verification);

        // Store phone verification status
        if (data.phoneVerification == true) {
          box.write("phone_verification", true);
        } else {
          box.write("phone_verification", false);
        }

        // Check if user exists in Firestore and add if not
        await _checkAndAddUser(userId, login);

        return data;
      } else {
        var apiError = apiErrorFromJson(response["data"]);
        throw apiError.message;
      }

    } /*catch (e) {
      throw 'Login failed: $e';
    }*/



  // Logout the user and clear storage
  void logout() {
    box.erase();
  }

  // Delete user account
  Future<void> deleteAccount() async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);

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
        box.erase();
      } else {
        var apiError = apiErrorFromJson(response.body);
        throw apiError.message;
      }
    } catch (e) {
      throw 'Delete account failed: $e';
    }
  }

  // Get user data from GetStorage
  LoginResponse? getUserData() {
    String? userId = box.read("userId");
    if (userId != null) {
      String? data = box.read(jsonDecode(userId));
      if (data != null) {
        return loginResponseFromJson(data);
      }
    }
    return null;
  }

  // Private method to check if user exists in Firestore, and add if not
  Future<void> _checkAndAddUser(String userId, LoginRequest login) async {
    var userbase = await db.collection("users")
        .withConverter(
      fromFirestore: UserData.fromFirestore,
      toFirestore: (UserData userdata, options) => userdata.toFirestore(),
    )
        .where("id", isEqualTo: userId)
        .get();

    if (userbase.docs.isEmpty) {
      final data = UserData(
        id: userId,
        name: "",
        email: login.email,
        photourl: "",
        location: "",
        fcmtoken: "",
        addtime: Timestamp.now(),
      );

      await db.collection("users")
          .withConverter(
        fromFirestore: UserData.fromFirestore,
        toFirestore: (UserData userdata, options) => userdata.toFirestore(),
      )
          .add(data);
    }
  }
}
