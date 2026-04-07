import 'dart:math';

import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  ClockPainter({required this.isDarkMode});
  var dateTime = DateTime.now();

  late bool isDarkMode;

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    // Background circle
    var fillBrush = Paint()
      ..color = isDarkMode ? Colors.grey[850]! : Colors.grey[200]!
      ..style = PaintingStyle.fill;

    // Outer border
    var outerBrush = Paint()
      ..color = isDarkMode ? Colors.white12 : Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.02;

    // Center dot
    var centerDotBrush = Paint()
      ..color = isDarkMode ? Colors.white : Colors.black
      ..style = PaintingStyle.fill;

    // Clock hands
    var secondHandBrush = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = radius * 0.02;

    var minuteHandBrush = Paint()
      ..color = isDarkMode ? Colors.white : Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = radius * 0.03;

    var hourHandBrush = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = radius * 0.04;

    // Draw clock face
    canvas.drawCircle(center, radius * 0.9, fillBrush);
    canvas.drawCircle(center, radius * 0.9, outerBrush);

    // Draw numbers
    var hourNumberRadius = radius * 0.75;
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 12; i > 0; i--) {
      // Calculate angle for number position (starting from 12 o'clock)
      double angle = -pi / 2 + (i * pi / 6);
      Offset numberPosition = Offset(
        centerX + cos(angle) * hourNumberRadius,
        centerY + sin(angle) * hourNumberRadius,
      );

      textPainter.text = TextSpan(
        text: i.toString(),
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: radius * 0.17,
          fontWeight: FontWeight.w600,
          fontFamily: 'Arial',
          height: 1.0,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        numberPosition.translate(
            -textPainter.width / 2, -textPainter.height / 2),
      );
    }

    // Draw minute markers
    for (double i = 0; i < 360; i += 6) {
      if (i % 30 != 0) {
        var markerAngle = -pi / 2 + (i * pi / 180);
        var markerLength = radius * (i % 30 == 0 ? 0.1 : 0.05);
        var x1 = centerX + (radius * 0.9 - markerLength) * cos(markerAngle);
        var y1 = centerY + (radius * 0.9 - markerLength) * sin(markerAngle);
        var x2 = centerX + radius * 0.9 * cos(markerAngle);
        var y2 = centerY + radius * 0.9 * sin(markerAngle);

        var markerBrush = Paint()
          ..color = isDarkMode ? Colors.white38 : Colors.black38
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), markerBrush);
      }
    }

    // Calculate hand angles
    var hourAngle =
        -pi / 2 + ((dateTime.hour % 12 + dateTime.minute / 60.0) * pi / 6);
    var minuteAngle = -pi / 2 + (dateTime.minute * pi / 30);
    var secondAngle = -pi / 2 + (dateTime.second * pi / 30);

    // Draw hour hand
    var hourHandX = centerX + radius * 0.5 * cos(hourAngle);
    var hourHandY = centerY + radius * 0.5 * sin(hourAngle);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    // Draw minute hand
    var minHandX = centerX + radius * 0.7 * cos(minuteAngle);
    var minHandY = centerY + radius * 0.7 * sin(minuteAngle);
    canvas.drawLine(center, Offset(minHandX, minHandY), minuteHandBrush);

    // Draw second hand
    var secHandX = centerX + radius * 0.75 * cos(secondAngle);
    var secHandY = centerY + radius * 0.75 * sin(secondAngle);
    canvas.drawLine(center, Offset(secHandX, secHandY), secondHandBrush);

    // Draw center dot
    canvas.drawCircle(center, radius * 0.04, centerDotBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
