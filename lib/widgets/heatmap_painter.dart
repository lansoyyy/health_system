import 'package:flutter/material.dart';

class HeatmapPainter extends CustomPainter {
  final List<Offset> data;
  final double maxValue;

  HeatmapPainter(this.data, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < data.length; i++) {
      var value = data[i].distance;
      var color =
          Color.lerp(Colors.blue[300], Colors.red[300], value / maxValue);
      var radius = value * 15;
      var paint = Paint()..color = color!;
      canvas.drawCircle(data[i], radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Heatmap extends StatelessWidget {
  final List<Offset> data;
  final double maxValue;

  const Heatmap({required this.data, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: CustomPaint(
        painter: HeatmapPainter(data, maxValue),
      ),
    );
  }
}
