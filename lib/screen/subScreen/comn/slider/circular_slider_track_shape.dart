import 'package:flutter/material.dart';
import 'dart:math';

class CircularSliderTrackShape extends SliderTrackShape {
  final double progress; // 진행 비율

  CircularSliderTrackShape({required this.progress});

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {

    final double trackDiameter = min(parentBox.size.width, parentBox.size.height);
    final double trackLeft = (parentBox.size.width - trackDiameter) / 2;
    final double trackTop = (parentBox.size.height - trackDiameter) / 2;

    return Rect.fromLTWH(trackLeft, trackTop, trackDiameter, trackDiameter);
  }

  @override
  void paint(
      PaintingContext context,
      Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required TextDirection textDirection,
        required Offset thumbCenter,
        Offset? secondaryOffset,
        bool isEnabled = false,
        bool isDiscrete = false,
      }) {
    final Paint activePaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? Colors.white // 활성화된 트랙 색상
      ..style = PaintingStyle.stroke
      ..strokeWidth = sliderTheme.trackHeight ?? 3.5;

    final Paint inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? Colors.grey // 비활성화된 트랙 색상
      ..style = PaintingStyle.stroke
      ..strokeWidth = sliderTheme.trackHeight ?? 3.5;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Offset center = Offset(
      trackRect.left + trackRect.width / 2,
      trackRect.top + trackRect.height / 2,
    );
    final double radius = trackRect.width / 2;

    // 활성화된 트랙 그리기
    context.canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // 시작 각도 (12시 방향)
      progress * 2 * pi, // 진행된 각도 (progress에 따라)
      false,
      activePaint,
    );

    // 비활성화된 트랙 그리기
    context.canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 + progress * 2 * pi, // 비활성화된 트랙 시작 각도
      2 * pi - progress * 2 * pi, // 비활성화된 각도
      false,
      inactivePaint,
    );
  }
}