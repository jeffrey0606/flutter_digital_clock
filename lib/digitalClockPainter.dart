import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as Math;

class DigitalClockPainter extends CustomPainter {
  final DateTime dateTime;
  final double dy;

  DigitalClockPainter({this.dateTime, this.dy});

  @override
  void paint(Canvas canvas, Size size) {

    _drawPMOrAMText(canvas, size);
    
    _waveAnimation(canvas, size);

    _rectangularSecondsPath(size, canvas, dateTime.second);
  }

  void _drawPMOrAMText(Canvas canvas, Size size) {
    final position = Offset(size.width - 50, size.height - 40);
    var text;
    dateTime.hour > 12 || dateTime.hour == 0 ? text = 'PM' : text = 'AM';

    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.cyan[200],
        fontSize: 20,
      ),
    );

    final tp = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    tp.layout();
    tp.paint(canvas, position);
  }

  void _waveAnimation(Canvas canvas, Size size) {
    final paintWave = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..strokeWidth = 5;

    final modHeight = size.height / 12;
    double hour = dateTime.hour.toDouble();
    int minute = dateTime.minute;

    if (hour > 12) {
      hour = hour - 12;
      hour = hour + ((minute / 4) / modHeight);
    } else if (hour == 0) {
      hour = 12;
    } else if (hour < 12) {
      hour = hour + ((minute / 4) / modHeight);
    }
    var leftSideOffset =
        Offset(0, (modHeight * (13 - hour)) - (modHeight * 0.5));
    var rightSideOffset =
        Offset(size.width, (modHeight * (13 - hour)) - (modHeight * 0.5));

    final wavePath = Path();

    //Top wave Cover
    final lenght = size.width / 3;
    //set of pionts #1
    var point1_1 = Offset(leftSideOffset.dx, leftSideOffset.dy);

    var point1_2 = Offset(
        Math.sqrt(_square(lenght) + rightSideOffset.dx), rightSideOffset.dy);

    var mid1 = Offset(
        (point1_1.dx + point1_2.dx) / 2, (point1_1.dy + point1_2.dy) / 2);

    //set of pionts #2
    var point2_1 = Offset(
        Math.sqrt(_square(lenght) + rightSideOffset.dx), rightSideOffset.dy);

    var point2_2 = Offset(Math.sqrt(_square(lenght * 2) + rightSideOffset.dx),
        rightSideOffset.dy);

    var mid2 = Offset(
        (point2_1.dx + point2_2.dx) / 2, (point2_1.dy + point2_2.dy) / 2);

    //set of pionts #3
    var point3_1 = Offset(Math.sqrt(_square(lenght * 2) + rightSideOffset.dx),
        rightSideOffset.dy);

    var point3_2 = Offset(Math.sqrt(_square(lenght * 3) + rightSideOffset.dx),
        rightSideOffset.dy);

    var mid3 = Offset(
        (point3_1.dx + point3_2.dx) / 2, (point3_1.dy + point3_2.dy) / 2);

    wavePath.lineTo(point1_1.dx, point1_1.dy);

    dy < 0
        ? wavePath.cubicTo(mid1.dx - 25, mid1.dy - dy, mid1.dx + 15,
            mid1.dy + dy, point1_2.dx, point1_2.dy)
        : wavePath.cubicTo(mid2.dx - 25, mid2.dy - dy, mid2.dx + 15,
            mid2.dy + dy, point2_2.dx, point2_2.dy);

    wavePath.cubicTo(mid3.dx - 25, mid3.dy - dy, mid3.dx + 15, mid3.dy + dy,
        point3_2.dx, point3_2.dy);

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);

    canvas.drawPath(wavePath, paintWave);
  }

  num _square(num val) {
    return val * val;
  }

  void _rectangularSecondsPath(Size size, Canvas canvas, int seconds) {
    final paintSecPath = Paint()
      ..color = Colors.cyan.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    var midSize = (size.width / 2), madeHeight = (size.height / 12);

    final secPath = Path();

    secPath.moveTo(size.width / 2, 3);
    secPath.lineTo(size.width / 2, 3);

    //Drawing Lines progressively according to time for
    //Each sides with an interval of 12 seconds
    if (seconds > 0 && seconds <= 12) {
      var width = (((midSize / 12) * seconds) + midSize);

      secPath.lineTo(width - 3, 3);
    } else if (seconds > 12 && seconds <= 24) {
      var height = (madeHeight * (seconds - 12));

      secPath.lineTo(size.width - 3, 3);
      secPath.lineTo(size.width - 3, height - 3);
    } else if (seconds > 24 && seconds <= 36) {
      var width = ((size.width / 12) * ((seconds - 37) * -1));

      secPath.lineTo(size.width - 3, 3);
      secPath.lineTo(size.width - 3, size.height - 3);
      secPath.lineTo(width - 3, size.height - 3);
    } else if (seconds > 36 && seconds <= 48) {
      var height = (madeHeight * ((seconds - 49) * -1));

      secPath.lineTo(size.width - 3, 3);
      secPath.lineTo(size.width - 3, size.height - 3);
      secPath.lineTo(3, size.height - 3);
      secPath.lineTo(3, height - 3);
    } else if (seconds > 48 && seconds <= 59 || seconds == 0) {
      seconds == 0 ? seconds = 60 : null;

      var width = ((midSize / 12) * (seconds - 48));

      secPath.lineTo(size.width - 3, 3);
      secPath.lineTo(size.width - 3, size.height - 3);
      secPath.lineTo(3, size.height - 3);
      secPath.lineTo(3, 3);
      secPath.lineTo(width, 3);
    }

    canvas.drawPath(secPath, paintSecPath);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
