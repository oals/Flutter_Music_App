import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomProgressIndicator extends StatefulWidget {
  const CustomProgressIndicator({
    super.key,
    required this.isApiCall
  });

  final bool isApiCall;

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(widget.isApiCall)...[
          SizedBox(height: 30,),
          CircularProgressIndicator(
            color: Color(0xffff0000),
          ),
        ],
        SizedBox(
          height: 12.h,
        )
      ],
    );
  }
}
