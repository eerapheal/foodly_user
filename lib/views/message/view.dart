import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/views/message/index.dart';

import 'chat/widgets/message_list.dart';
import 'package:get/get.dart';
class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MessageController());
    return Container(
      color: kWhite,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
            backgroundColor: kWhite,
            leading: const CommonBackButton(),

            title: Text(
              "Messages",
              style: TextStyle(
                  color: kPrimary,
                  fontSize: screenIconSize(kFontSizeLarge),
                  fontWeight: FontWeight.w600
              ),
            )
        ),
        body: const MessageList(),
      ),
    );
  }
}
