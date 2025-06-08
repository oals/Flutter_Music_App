import 'package:flutter/material.dart';
import 'dart:math';

class CustomProgressIndicatorItem extends StatefulWidget {
  const CustomProgressIndicatorItem({Key? key}) : super(key: key);

  @override
  _CustomProgressIndicatorItemState createState() => _CustomProgressIndicatorItemState();
}

class _CustomProgressIndicatorItemState extends State<CustomProgressIndicatorItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: List.generate(8, (index) {
              final angle = (index * pi / 4) + (_controller.value * 2 * pi);
              return Positioned(
                left: 20 + 15 * cos(angle),
                top: 20 + 15 * sin(angle),
                child: Container(
                  width: 4,  // 너비를 늘려서 긴 타원형으로 만들기
                  height: 4,
                  color: Colors.grey,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}