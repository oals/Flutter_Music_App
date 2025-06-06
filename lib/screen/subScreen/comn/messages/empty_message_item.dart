import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmptyMessageItem extends StatelessWidget {
  EmptyMessageItem({
    super.key,
    required this.paddingHeight
  });

  double paddingHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width : 100.w,
      padding: EdgeInsets.only(top: paddingHeight),
      child: Text(
        'Empty',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
