import 'dart:math';

import 'package:flutter/material.dart';

class CouponClipper extends CustomClipper<Path> {
  final int holeCount;
  final double lineRate;
  final bool dash;
  final Color lineColor;

  CouponClipper({this.holeCount = 6, this.lineRate = 0.3, this.dash = true, this.lineColor = Colors.red});

  @override
  Path getClip(Size size) {
    var rect = Rect.fromLTRB(0, 0, size.width, size.height);
    var w = rect.width;
    var h = rect.height;

    var d = h / (1 + 2 * holeCount);

    var path = Path();
    path.addRect(rect);

    _formHoldLeft(path, d);
    _formHoldRight(path, w, d);
    _formHoleTop(path, rect);
    _formHoleBottom(path, rect);
    path.fillType = PathFillType.evenOdd;

    return path;
  }

  void _formHoleBottom(Path path, Rect rect) {
    path.addArc(Rect.fromCenter(center: Offset(lineRate * rect.width, rect.height), width: 13.0, height: 13.0), pi, pi);
  }

  void _formHoleTop(Path path, Rect rect) {
    path.addArc(Rect.fromCenter(center: Offset(lineRate * rect.width, 0), width: 13.0, height: 13.0), 0, pi);
  }

  _formHoldLeft(Path path, double d) {
    for (int i = 0; i < holeCount; i++) {
      var left = -d / 2;
      var top = 0.0 + d + 2 * d * (i);
      var right = left + d;
      var bottom = top + d;
      path.addArc(Rect.fromLTRB(left, top, right, bottom), -pi / 2, pi);
    }
  }

  _formHoldRight(Path path, double w, double d) {
    for (int i = 0; i < holeCount; i++) {
      var left = -d / 2 + w;
      var top = 0.0 + d + 2 * d * (i);
      var right = left + d;
      var bottom = top + d;
      path.addArc(Rect.fromLTRB(left, top, right, bottom), pi / 2, pi);
    }
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
