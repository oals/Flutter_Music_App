import 'dart:math';

import 'package:flutter/material.dart';

class TrackBarGraphAnimation extends StatefulWidget {

  final bool isPlaying;

  TrackBarGraphAnimation({required this.isPlaying});

  @override
  _TrackBarGraphAnimationState createState() => _TrackBarGraphAnimationState();
}

class _TrackBarGraphAnimationState extends State<TrackBarGraphAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final int barCount = 6;
  late int loadingOption;

  @override
  void initState() {
    super.initState();
    loadingOption = 0;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (loadingOption == 0 && loadingOption != -1) {
      loadingOption = -1;
      Future.delayed(Duration(milliseconds: 600)).then((value) {
        loadingOption = 1;
      });
    }

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
              height: loadingOption <= 0 ? 1 : widget.isPlaying ? height : 1,
              color: Colors.white,
            );
          }),
        );
      },
    );
  }
}