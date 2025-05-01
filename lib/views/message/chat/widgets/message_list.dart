import 'package:foodly_user/common/cached_image_loader.dart';
import 'package:foodly_user/common/entities/message.dart';
import 'package:foodly_user/common/show_snack_bar.dart';
import 'package:foodly_user/common/utils/date.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:foodly_user/main.dart';
import 'package:foodly_user/views/message/chat/index.dart';
import 'package:foodly_user/views/message/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../common/values/colors.dart';

class MessageList extends GetView<MessageController> {
  const MessageList({Key? key}) : super(key: key);

  Widget messageListItem(Message item){

    return Container(
      padding: EdgeInsets.only(top:10.w, left: 15.w, right: 15.w),
      child: InkWell(
          onTap: (){

            Get.toNamed(RouteNames.getChatPageRoute(
                item.doc_id!,
                item.token!,
                item.name!

            )/*,arguments: {
              "doc_id":item.doc_id,
              "to_uid":item.token,
              "to_name":item.name,

            }*/);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                padding: EdgeInsets.only(top: 0.w, left: 0.w, right: 15.w),
                child: SizedBox(
                  width: screenButtonWidth(64),
                  height: screenButtonHeight(54),
                  child: CachedNetworkImage(
                    imageUrl: item.avatar!,
                    imageBuilder: (context, imageProvider) => Container(
                      width: screenButtonWidth(64),
                      height: screenButtonHeight(54),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(appBorderRadius)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,

                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Image(
                      image: AssetImage('assets/images/feature-1.png'),
                    ),
                  ),
                ),
              ),
              // Message container
              Expanded( // Use Expanded to ensure the second container takes available space
                child: Container(
                  padding: EdgeInsets.only(top: 0.w, left: 0.w, right: 5.w),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Texts (name and message)
                      Expanded(  // Expand this part to take available space
                        child: SizedBox(
                          height: screenButtonHeight(49),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Text(
                                item.name!,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: "Avenir",
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.thirdElement,
                                  fontSize: screenFontSize(kFontSizeSmall),
                                ),
                              ),
                              // Message
                              SingleChildScrollView(
                                child: Text(
                                  item.last_msg ?? "",
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: "Avenir",
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.thirdElement,
                                    fontSize: screenFontSize(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Time and message count
                      SizedBox(
                        height: screenButtonHeight(54),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Time
                            Text(
                              duTimeLineFormat((item.last_time as Timestamp).toDate()),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: "Avenir",
                                fontWeight: FontWeight.normal,
                                color: AppColors.thirdElementText,
                                fontSize: screenFontSize(kFontSizeSmall),
                              ),
                            ),
                            // Unread message count
                            item.msg_num == 0
                                ? Container()
                                : Container(
                              padding: EdgeInsets.only(
                                  left: 4.w,
                                  right: 4.w,
                                  top: 0.h,
                                  bottom: 0.h),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Text(
                                "${item.msg_num}",
                                textAlign: TextAlign.end,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.primaryElementText,
                                  fontSize: screenFontSize(kFontSizeSmall),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Obx(
            ()=>CustomScrollView(
          slivers: [
            SliverPadding(padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                        (context, index){
                      var item = controller.state.msgList[index];
                      return messageListItem(item);
                    },
                    childCount: controller.state.msgList.length
                ),
              ),
            ),

          ],
        )
    );
  }
}
