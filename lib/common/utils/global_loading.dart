import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodly_user/constants/constants.dart';

class GlobalLoading extends StatelessWidget {
   GlobalLoading({super.key, this.bottom, this.top,this.left, this.right});
  double? bottom;
  double? top;
  double? right;
  double? left;
  @override
  Widget build(BuildContext context) {
    return   Positioned(
      bottom: bottom,
      left: left,
      right: right,
      top: top,
      child: const CircleAvatar(
        backgroundColor: kSecondary,
        radius: 20, // Adjust height to make it smaller
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation<Color>(kPrimary),
        ),
      ),
    );
  }
}
