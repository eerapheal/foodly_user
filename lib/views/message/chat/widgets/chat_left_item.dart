import 'package:foodly_user/common/entities/entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:foodly_user/constants/routes_names.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/routes/names.dart';

Widget ChatLeftItem(Msgcontent item) {
  bool isLink(String text) {
    final Uri? uri = Uri.tryParse(text);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https' || uri.scheme == 'www');
  }

  void openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }

  return Container(
    padding: EdgeInsets.only(
        top: 10.w, left: kPaddingMedium, right: kPaddingMedium, bottom: 10.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: screenButtonWidth(width),
                minHeight: screenButtonHeight(40)),
            child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenButtonWidth(10),
                    vertical: screenButtonHeight(10)),
                decoration:  BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.all(Radius.circular(appBorderRadius))),
                child: item.type == "text"
                    ? isLink(item.content!)
                    ? GestureDetector(
                  onTap: () => openLink(item.content!),
                  child: Text(
                    "${item.content}",
                    style: const TextStyle(
                        color: kWhite,
                        decoration: TextDecoration.underline),
                  ),
                )
                    : Text(
                  "${item.content}",
                  style: const TextStyle(color: kWhite),
                )
                    : ConstrainedBox(
                  constraints: const BoxConstraints(
                    //  maxWidth: 90,
                  ),
                  child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              '${RouteNames.chatImageView}/${Uri.encodeComponent(item.content ?? "")}',
                            );
                          },
                          child: CachedNetworkImage(
                            width: screenButtonWidth(300),
                            height: screenButtonHeight(200),
                            fit: BoxFit.cover,
                            imageUrl: "${item.content}",
                          ),
                        ),
                      )))
      ],
    ),
  );
}
