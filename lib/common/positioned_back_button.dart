import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/utils/common_back_button.dart';

class PositionedBackButton extends StatelessWidget {
  const PositionedBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: kIsWeb ? 10.h : 40.h,
      left: 0,
      child: const CommonBackButton(),
    );
  }
}
