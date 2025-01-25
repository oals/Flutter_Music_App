import 'package:flutter/material.dart';

class Visualizer extends StatelessWidget {
  final double amplitude; // 이 값은 오디오 비트에 따라 업데이트 됩니다.

  Visualizer({required this.amplitude});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: VisualizerPainter(amplitude),
      size: Size(double.infinity, 100),
    );
  }
}

class VisualizerPainter extends CustomPainter {
  final double amplitude;

  VisualizerPainter(this.amplitude);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue; // 색상을 흰색으로 변경
    final width = size.width/ 2; // 막대의 수
    for (int i = 0; i < 10; i++) {
      canvas.drawRect(
        Rect.fromLTWH(i * width, size.height - (amplitude * 10), width - 2, amplitude * 10),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(VisualizerPainter oldDelegate) {
    return oldDelegate.amplitude != amplitude;
  }
}
