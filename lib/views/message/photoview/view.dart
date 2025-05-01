import 'package:foodly_user/common/common_loading_screen.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/common/values/common_error_screen.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/views/message/photoview/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class PhotoImageView extends StatelessWidget {
  const PhotoImageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<PhotoImageViewController>();
    // Decode and fetch the image URL from parameters
    final String? encodedImgUrl = Get.parameters['imgUrl'];
    if (encodedImgUrl == null || encodedImgUrl.isEmpty) {
      return const CommonErrorScreen();
    }else{
      controller.url=encodedImgUrl;
      controller.loading=false;
    }
    if (controller.loading) {
      return const CommonLoadingScreen();
    } else if (controller.loading==false) {
      return _buildContent();
    } else {
      return const CommonErrorScreen();
    }
  }

  Widget _buildContent() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      color: kWhite,
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          leading: CommonBackButton(),
        ),
        body: PhotoView(
          imageProvider: NetworkImage(Get.find<PhotoImageViewController>().url),
        ),
      ),
    );
  }
}
