import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodly_user/common/shimmers/shimmer_widget.dart';
import 'package:foodly_user/constants/constants.dart';

class CatergoriesShimmer extends StatelessWidget {
  const CatergoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 10),
      height: screenButtonHeight(140),

      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ShimmerWidget(
                    shimmerWidth: screenButtonHeight(100),
                    shimmerHieght: screenButtonWidth(100),
                    shimmerRadius: 12),
              ],
            );
          }),
    );
  }
}
