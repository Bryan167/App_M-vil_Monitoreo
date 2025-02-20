import 'dart:math';
import 'package:flutter/material.dart';

class Circleprogress extends CustomPainter {
  double value;
  String type; // "temp", "humidity", "gas", or "ph"

  Circleprogress(this.value, this.type);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    int maximumValue;
    Paint arcPaint;

    // Define maximum value and color based on measurement type
    if (type == "temp") {
      maximumValue = 50;
      arcPaint = Paint()
        ..strokeWidth = 14
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    } else if (type == "humidity") {
      maximumValue = 100;
      arcPaint = Paint()
        ..strokeWidth = 14
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    } else if (type == "gas") {
      maximumValue = 500;
      arcPaint = Paint()
        ..strokeWidth = 14
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    } else if (type == "ph") {
      maximumValue = 14; // typical pH scale maximum
      arcPaint = Paint()
        ..strokeWidth = 14
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
    } else {
      return; // Skip if type is invalid
    }

    Paint outerCircle = Paint()
      ..strokeWidth = 14
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 14;
    canvas.drawCircle(center, radius, outerCircle);

    double angle = 2 * pi * (value / maximumValue);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      arcPaint,
    );
  }
}
