import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        height: 10,
        child:kIsWeb? Divider(thickness: 0.3,):null,
      ),
    );
  }
}
