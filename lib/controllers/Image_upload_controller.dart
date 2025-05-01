// ignore_for_file: prefer_final_fields, depend_on_referenced_packages
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:foodly_user/common/show_snack_bar.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageUploadController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var coverFile = Rxn<File>();
  var logoFile = Rxn<File>();

  //during image loading
  RxBool _imageLoading = false.obs;

  get imageLoading => _imageLoading.value;
  set setImageLoading(bool val) => _imageLoading.value=val;

  //during submittion
  RxBool _loading = false.obs;
  get loading => _loading.value;
  set setLoading(bool val) => _loading.value=val;


  RxString _chatImage = ''.obs;
  String get chatImage => _chatImage.value;
  set chatImage(String val) =>_chatImage.value=val;

  RxString _coverUrl = ''.obs;

  String get coverUrl => _coverUrl.value;

  set coverUrl(String value) {
    _coverUrl.value = value;
  }
  RxString _editImageUrl = ''.obs;

  String get editImageUrl => _editImageUrl.value;

  set setEditImageUrl(String value){
    _editImageUrl.value=value;
  }


  RxString _logoUrl = ''.obs;

  String get logoUrl => _logoUrl.value;

  set logoUrl(String value) {
    _logoUrl.value = value;
  }


  Future<void> uploadImageToFirebase(String type) async {

    if (type == "logo") {
      if(!kIsWeb){
        if (logoFile.value == null) return;
        try {
          String fileName =
              'images/${DateTime.now().millisecondsSinceEpoch}_${logoFile.value!.path.split('/').last}';
          TaskSnapshot snapshot = await FirebaseStorage.instance
              .ref()
              .child(fileName)
              .putFile(logoFile.value!);
          logoUrl = await snapshot.ref.getDownloadURL();
        } catch (e) {
          showCustomSnackBar(e.toString());
          debugPrint("Error uploading 1 ${e.toString()}");
        }
      }else{
        uploadImageWithUrlType("logo", edit: false);
      }

    } else if (type == "cover") {
      if(!kIsWeb){
        if (coverFile.value == null) return;
        try {
          String fileName =
              'images/${DateTime.now().millisecondsSinceEpoch}_${coverFile.value!.path.split('/').last}';
          TaskSnapshot snapshot = await FirebaseStorage.instance
              .ref()
              .child(fileName)
              .putFile(coverFile.value!);
          coverUrl = await snapshot.ref.getDownloadURL();
        } catch (e) {
          debugPrint("Error uploading");
        }
      }else{
        uploadImageWithUrlType("cover", edit: false);
      }

    } else if(type=="chat"){
      await uploadImageWithUrlType("chat");
    }
  }

  Future<void> uploadImageWithUrlType(String imageUrlType, {bool edit=false}) async {
    if (kIsWeb) {
      _imageLoading.value= true;
      try {
        // File Picker for web
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png'],
          withData: true, // Ensures `bytes` is available
        );
        if (result == null) {
          showCustomSnackBar("File selection was canceled.");
          print("File picker was canceled by the user.");
          _imageLoading.value= false;

          return;
        }
        if (result.files.isEmpty) {
          showCustomSnackBar("No file was selected.");
          print("File picker returned an empty result.");
          _imageLoading.value= false;

          return;
        }
        PlatformFile platformFile = result.files.first;
        Uint8List? fileBytes = platformFile.bytes;

        if (fileBytes == null) {
          showCustomSnackBar("File bytes are null.");
          print("File bytes are null.");
          _imageLoading.value= false;

          return;
        }
        // Check if the file extension is allowed
        String? fileExtension = platformFile.extension?.toLowerCase(); // Normalize extension to lowercase
        if (fileExtension == null || !['jpg', 'png'].contains(fileExtension)) {
          showCustomSnackBar("Invalid file format. Please select a JPG or PNG image.");
          _imageLoading.value= false;

          return;
        }
        const int maxFileSize = 2000 * 1024; // 300KB in bytes
        if (platformFile.size > maxFileSize) {
          showCustomSnackBar("File too large. Please select an image smaller than 350KB.");
          _imageLoading.value= false;

          return;
        }
        // Generate unique file name
        String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}_${platformFile.name}';

        // Upload the file
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        TaskSnapshot snapshot = await storageRef.putData(
          fileBytes,
          SettableMetadata(contentType: 'image/${platformFile.extension}'),
        );

        String url = await snapshot.ref.getDownloadURL();

        if(edit==true){
          _editImageUrl.value=url;
          debugPrint("Uploaded image URL (web): $_editImageUrl.value");
          _imageLoading.value= false;
          return;
        }
        // Get download URL
        if(imageUrlType=="logo"){
          logoUrl = await snapshot.ref.getDownloadURL();

        }else if(imageUrlType=="cover"){
          coverUrl = await snapshot.ref.getDownloadURL();

        }else if(imageUrlType=="chat"){
          chatImage = await snapshot.ref.getDownloadURL();
        }

        _imageLoading.value=false;

        showCustomSnackBar("Image uploaded successfully!", title: "Image upload");
      } catch (e, trace) {
        debugPrint("Error uploading image to Firebase (web): $e");
        showCustomSnackBar("Error: $e");

      }
    } else {
    }
  }

  Future<void> deleteOldImage(String imageUrl) async {
    try {

      print("The given url is for deletion ${imageUrl}");
      // Extract the file reference from the URL
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);

      // Try to get the metadata for the file
      final metadata = await ref.getMetadata();

      // Check if metadata is empty or not
      if (metadata != null && metadata.name.isNotEmpty) {
        print("Image exists, proceeding with deletion.");

        // Proceed to delete the image if metadata is valid
        await ref.delete();
        print("Old image deleted successfully.");
        showCustomSnackBar("Old image deleted successfully", title: "Image delete");
      } else {
        // If metadata is empty or invalid
        print("Image metadata is empty or invalid.");
        showCustomSnackBar("Image metadata is empty or invalid", title: "Image delete");
        throw Exception("Image not found or metadata is empty.");
      }
    } catch (e) {
      // Catch errors such as image not found
      print("Error deleting old image: $e");

      // Show error message in the snackbar
      showCustomSnackBar("Old image cannot be deleted or does not exist", title: "Image delete");
      throw Exception("Failed to delete old image.");
    }
  }


/* var feedbackFile = Rxn<File>();

  RxString _feedBackUrl = ''.obs;

  String get feedBackUrl => _feedBackUrl.value;

  set feedBackUrl(String value) {
    _feedBackUrl.value = value;
  }

  Future<void> uploadImageToFirebase() async {
    if (feedbackFile.value == null) return;
    try {
      String fileName =
          'images/${DateTime.now().millisecondsSinceEpoch}_${feedbackFile.value!.path.split('/').last}';
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child(fileName)
          .putFile(feedbackFile.value!);
      feedBackUrl = await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error uploading");
    }
  }

  Future<File> writeBytesToFile(Uint8List bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/$fileName');

    return await file.writeAsBytes(bytes);
  }*/
}
