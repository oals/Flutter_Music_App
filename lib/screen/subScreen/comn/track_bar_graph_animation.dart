import 'dart:math';

import 'package:flutter/material.dart';

class TrackBarGraphAnimation extends StatefulWidget {

  final bool isPlaying; // 진행 비율

  TrackBarGraphAnimation({required this.isPlaying});



  @override
  _TrackBarGraphAnimationState createState() => _TrackBarGraphAnimationState();
}

class _TrackBarGraphAnimationState extends State<TrackBarGraphAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final int barCount = 6; // 막대 그래프 개수

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // 애니메이션 반복
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(barCount, (index) {
            final double height = 20 + sin((_controller.value * 2 * pi) + (index * pi / 6)) * 20;
            return  AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              margin: const EdgeInsets.symmetric(horizontal: 1),
              width: 2,
              height: widget.isPlaying ? height : 1,
              color: Colors.white,
            );
          }),
        );
      },
    );
  }
}