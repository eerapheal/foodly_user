import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:foodly_user/common/utils/app_get_home.dart';
import 'package:foodly_user/constants/constants.dart';

class CommonBackButton extends StatelessWidget {
  const CommonBackButton({
    super.key,
    this.color = kPrimary,
    this.icon = Ionicons.chevron_back_circle,
    this.onPressed
  });

  final Color color;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if(onPressed!=null){
          onPressed!();
        }
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          debugPrint("Popping screens");
        } else {
          AppGetHome().appGetHome();
        }
      },
      icon: Icon(
        icon,
        color: color,
        size: screenFontSize(38),
      ),
    );
  }
}
