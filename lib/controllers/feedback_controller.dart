// ignore_for_file: depend_on_referenced_packages, prefer_final_fields
import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/models/environment.dart';
import 'package:foodly_user/models/feedback_model.dart';
import 'package:foodly_user/models/sucess_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// // // START_DISABLE
// import 'dart:html' as html;
// // // END_DISABLE
class UserFeedBackController extends GetxController {
  final box = GetStorage();

  var feedbackFile = Rxn<File>();
  var feedbackHtml = Rxn<Uint8List>();

  RxString _feedBackUrl = ''.obs;
  RxString _feedBackHtmlUrl = ''.obs;

  String get feedBackUrl => _feedBackUrl.value;

  String get feedBackHtmlUrl => _feedBackHtmlUrl.value;

  set feedBackUrl(String value) {
    _feedBackUrl.value = value;
  }

  set feedBackHtmlUrl(String value) {
    _feedBackHtmlUrl.value = value;
  }

  void inspectFeedbackFile(Uint8List file) {
    if (file.isEmpty) {
      print("No data received.");
      return;
    }

    print("Inspecting feedback file...");
    if (kIsWeb) {
      // Platform-specific inspection for web
      print("Platform: Web");
      print("Received Uint8List with ${file.length} bytes");
      // Further inspection logic for Uint8List on web (if needed)
    } else {
      // Platform-specific inspection for mobile/desktop
      print("Platform: Mobile/Desktop");
      print("Received Uint8List with ${file.length} bytes");
      // Further inspection logic for Uint8List on native (if needed)
    }
  }

  /// Web: Handles binary data and returns `Uint8List`.
///
// // // // START_DISABLE
// Future<Uint8List> handleScreenshotForWeb(Uint8List bytes,
// String fileName) async {
// 
// print("Bytes received for web: ${bytes.take(10).toList()}");
// 
// 
// String fileExtension = '';
// if (bytes.length >= 8) {
// if (bytes[0] == 0x89 &&
// bytes[1] == 0x50 &&
// bytes[2] == 0x4E &&
// bytes[3] == 0x47 &&
// bytes[4] == 0x0D &&
// bytes[5] == 0x0A &&
// bytes[6] == 0x1A &&
// bytes[7] == 0x0A) {
// fileExtension = 'png';
// } else if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
// fileExtension = 'jpg';
// } else {
// fileExtension = 'jpg'; // Default to JPG if unknown format
// }
// }
// 
// 
// final finalFileName = '$fileName.$fileExtension';
// print("Final file name for web: $finalFileName");
// 
// 
// final blob = html.Blob([bytes]);
// final url = html.Url.createObjectUrlFromBlob(blob);
// 
// final anchor = html.AnchorElement(href: url)
// ..target = 'blank'
// ..download = finalFileName
// ..click();
// 
// html.Url.revokeObjectUrl(url); // Free memory
// inspectFeedbackFile(bytes);
// 
// return bytes;
// }
// // // // END_DISABLE
  /// Mobile/Desktop: Saves binary data to a file and returns the `File`.
  Future<File> handleScreenshotForMobile(Uint8List bytes,
      String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    print("Saving screenshot to: ${file.path}");

    // Write bytes to the file
    await file.writeAsBytes(bytes);
    return file;
  }
  Future<void> uploadImageToFirebaseWeb(Uint8List imageData, String feedback) async {
    if (imageData.isEmpty) {
      print("Step 1: Image data is empty.");
      return;
    }

    try {
      // Generate a unique file name for the image
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}_feedback_image.png';
      print("Step 2: Generated file name: $fileName");

      // Upload the binary data to Firebase
      print("Step 3: Uploading data to Firebase Storage...");
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child(fileName) // File path in Firebase Storage
          .putData(imageData); // Upload the binary data
      print("Step 4: Upload successful");

      // Get the download URL of the uploaded file
      String feedBackUrl = await snapshot.ref.getDownloadURL();
      print("Step 5: Image uploaded, URL: $feedBackUrl");

      // Create a FeedbackModel with the message and the image URL
      FeedbackModel model = FeedbackModel(message: feedback, imageUrl: feedBackUrl);
      print("Step 6: Created FeedbackModel with message: $feedback and imageUrl: $feedBackUrl");

      // Convert the model to JSON
      String feed = feedbackModelToJson(model);
      print("Step 7: Feedback JSON: $feed");

      // Send feedback (API call or other mechanism)
      sendFeedBack(feed);
      print("Step 8: Feedback sent.");
    } catch (e) {
      print("Step 9: Something went wrong during upload: ${e.toString()}");
    }
  }


  Future<void> uploadImageToFirebaseMobile(String feedback) async {
    //inspectFeedbackFile(feedbackFile.value);
    if (feedbackFile.value == null) {
      print("Step 1: No file selected.");
      return;
    }
    try {


      String fileName =
          'images/${DateTime.now().millisecondsSinceEpoch}_${feedbackFile.value!.path.split('/').last}';

        // Mobile/Desktop platform (native upload)
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref()
            .child(fileName)
            .putFile(feedbackFile.value!);

        String feedBackUrl = await snapshot.ref.getDownloadURL();

        FeedbackModel model =
            FeedbackModel(message: feedback, imageUrl: feedBackUrl);
        String feed = feedbackModelToJson(model);
        sendFeedBack(feed);
        print("Step 15: Feedback sent.");

    } catch (e) {
      print("Step 16: Something went wrong during upload: ${e.toString()}");
    }
  }


  RxBool isLoading = false.obs;

  set setLoading(bool value) => isLoading.value = value;

  void sendFeedBack(String feedback) async {
    String token = box.read('token');
    String accessToken = jsonDecode(token);
    setLoading = true;

    var url = Uri.parse('${Environment.appBaseUrl}/api/users/feedback');
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: feedback,
      );
      if (response.statusCode == 201) {
        setLoading = false;

        SuccessResponse success = successResponseFromJson(response.body);
        Get.snackbar(
          'Feedback Sent',
          success.message,
          duration: const Duration(seconds: 2),
          backgroundColor: kPrimary,
          colorText: kLightWhite,
        );
      }
    } catch (e) {
      setLoading = false;
      print("Something went wrong ${e.toString()}");
    } finally {
      setLoading = false;
    }
  }
}
// // // // START_DISABLE
// Future<Uint8List> fetchImageData(String imageUrl) async {
// final response =
// await html.HttpRequest.request(imageUrl, responseType: 'arraybuffer');
// if (response.status == 200) {
// return response.response as Uint8List; // Return binary data
// } else {
// throw Exception("Failed to fetch image");
// }
// }
// // // // END_DISABLE
