import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';
import 'package:foodly_user/common/utils/global_loading.dart';
import 'package:foodly_user/constants/constants.dart';

class CommonLoadingScreen extends StatelessWidget {
  const CommonLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kWhite,
      padding: EdgeInsets.symmetric(horizontal: kIsWeb?padding:8, vertical: kIsWeb?10.h:0.h),
      child: Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(
            backgroundColor: kWhite,
            leading: const CommonBackButton(),
          ),
          body: Center(
            child: Stack(
              children: [GlobalLoading()],
            ),
          )),
    );
  }
}
