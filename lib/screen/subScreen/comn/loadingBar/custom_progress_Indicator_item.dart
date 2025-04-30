import 'package:flutter/material.dart';


class CustomProgressIndicatorItem extends StatelessWidget {
  const CustomProgressIndicatorItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
        "assets/images/loading.gif",
        width: 30,
        height: 30,
      );
  }
}
