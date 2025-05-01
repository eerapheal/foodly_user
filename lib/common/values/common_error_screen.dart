import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/not_found.dart';
import 'package:foodly_user/constants/constants.dart';

class CommonErrorScreen extends StatelessWidget {
  const CommonErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: kIsWeb?padding:8, vertical: kIsWeb?10.h:40.h),
      child: const NotFoundPage(crash: true,),
    );
  }
}
