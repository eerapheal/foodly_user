import 'package:flutter/material.dart';
import 'package:foodly_user/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.shimmerWidth, required this.shimmerHieght, required this.shimmerRadius});

  final double shimmerWidth;
  final double shimmerHieght;
  final double shimmerRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: shimmerWidth,
        height: shimmerHieght,
        margin: const EdgeInsets.only(right: 12, top: 8.0),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              return   _buildShimmerLine(height: shimmerHieght-20, width: shimmerWidth-15, radius: shimmerRadius);

            })


    );
  }

  Widget _buildShimmerLine(
      {required double height, required double width, required double radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: kSecondaryLight,
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
