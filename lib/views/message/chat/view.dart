import 'package:flutter/foundation.dart';
import 'package:foodly_user/common/common_loading_screen.dart';
import 'package:foodly_user/common/show_dialogue_app.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/controllers/Image_upload_controller.dart';
import 'package:foodly_user/controllers/login_controller.dart';
import 'package:foodly_user/views/auth/widgets/email_textfield.dart';
import 'package:foodly_user/views/message/chat/widgets/chat_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Gallery"),
                  onTap: () {
                    controller.imgFromGallery();
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text("Camera"),
                  onTap: () {},
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => ImageUploadController());
    return controller.loading == true
        ? const CommonLoadingScreen()
        : Container(
            color: kWhite,
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Scaffold(
              backgroundColor: kWhite,
              appBar: AppBar(
                backgroundColor: kWhite,
                automaticallyImplyLeading: false,
                leading: const CommonBackButton(),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 10),
                    // Space between the back button and avatar
                    InkWell(
                      onTap: () {
                        // Handle avatar tap
                      },
                      child: SizedBox(
                        width: 44,
                        height: 44,
                        child: CachedNetworkImage(
                          imageUrl: controller.state.to_avatar.value,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              // Circular avatar
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Image(
                            image:
                                AssetImage('assets/images/profile-photo.png'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Space between avatar and name
                    // Name and Location
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.state.to_name.value,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.bold,
                            color: kPrimary,
                            fontSize: 16,
                          ),
                        ),
                        Obx(() => Text(
                              controller.state.to_location.value,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.normal,
                                color: kPrimary,
                                fontSize: 14,
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  const ChatList(),
                  Positioned(
                    bottom: 0,
                    height: 60,
                    right: 0,
                    left: 0,
                    child: Container(
                      margin: EdgeInsets.only(left: kPaddingMedium,right: kPaddingMedium, bottom: 10),
                      height: 50,
                      color: kWhite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: screenButtonWidth(kIsWeb ? 330 : 250),
                              
                              // Maximum width or fallback
                            ),
                            child: SizedBox(
                              width: kIsWeb
                                  ? screenButtonWidth(725.w)
                                  : screenButtonWidth(300.w),
                              height: 40,
                              child: SizedBox(
                                  // width: kIsWeb ? screenButtonWidth(720.w) : (width - 40.w),
                                  child: EmailTextField(
                                //focusNode: _passwordFocusNode,
                                hintText: "Type in here",
                                //controller: _usernameController,
                                controller: controller.textController,

                                focusNode: controller.contentNode,
                                prefixIcon: Icon(
                                  CupertinoIcons.chat_bubble_2,
                                  color: Theme.of(context).dividerColor,
                                  size: 20.h,
                                ),
                                keyboardType: TextInputType.text,
                              )),
                            ),
                          ),

                          Expanded(child: Container()),
                          //photo button
                          Container(
                            margin: EdgeInsets.only(left: 5.w, bottom: 0),
                            child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: const Icon(
                                  Icons.photo_outlined,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                              ),
                              onTap: () async {
                                if (kIsWeb) {
                                  final controllerImg =
                                      Get.find<ImageUploadController>();
                                  await controllerImg
                                      .uploadImageWithUrlType("chat");
                                  String imgPath = controllerImg.chatImage;
                                  controller.sendImageMessage(imgPath);
                                } else {
                                  _showPicker(context);
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          //send button
                          Container(
                            margin: EdgeInsets.only(left: 5.w, bottom: 0),
                            width: screenButtonWidth(70),
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(appBorderRadius),
                                color: kPrimary,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 0.5,
                                      spreadRadius: 1.0,
                                      offset: const Offset(0, 1),
                                      color: kPrimary.withOpacity(0.2))
                                ]),
                            child: GestureDetector(
                                child: const Center(
                                    child: Text(
                                  "Send",
                                  style: TextStyle(color: kOffWhite),
                                )),
                                onTap: () {
                                  controller.sendMessage();
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    left: 100,
                    right: 100,
                    top: 100,
                    bottom: 100,
                    child: Obx(() {
                      return Get.find<ImageUploadController>().imageLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink();
                    }),
                  )
                ],
              ),
            ),
          );
  }
}
