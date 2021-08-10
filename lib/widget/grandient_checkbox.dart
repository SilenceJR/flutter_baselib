import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GradientCheckBox extends StatelessWidget {
  final bool value;
  final double width;
  final double height;
  final colors;

  GradientCheckBox({this.value = false, this.width = 20, this.height = 20, this.colors = const []});

/*  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<GradientCheckBox> {*/
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: value
            ? DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors, transform: GradientRotation(pi / 4)),
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 15,
                ),
              )
            : DecoratedBox(
                decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFC4C4C4)),
              )));
  }
}
