import 'package:foodly_user/common/values/colors.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/views/message/chat/controller.dart';
import 'package:foodly_user/views/message/chat/widgets/chat_right_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodly_user/views/message/photoview/index.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_left_item.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PhotoImageViewController());
    return Obx(
        ()=>Container(
          color:kWhite,
          padding: EdgeInsets.only(bottom: 50.h),
          child: CustomScrollView(
            reverse: true,
            controller: controller.msgScrolling,
            slivers: [
              SliverPadding(padding: EdgeInsets.symmetric(vertical: 0.w,horizontal: 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (context, index){

                        var item = controller.state.msgcontentList[index];

                        if(controller.user_id==item.uid){
                          return ChatRightItem(item);
                        }
                        return ChatLeftItem(item);
                      },
                    childCount: controller.state.msgcontentList.length
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
