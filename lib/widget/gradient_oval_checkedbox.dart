import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GradientOvalCheckedBox extends StatelessWidget {
  final double size;
  final Color? borderColor;
  final List<Color>? checkColor;
  final bool value;

  GradientOvalCheckedBox({this.value = false, this.size = 20, this.borderColor, this.checkColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: EdgeInsets.all(size / 4),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: value ? LinearGradient(colors: checkColor ?? [Colors.black, Colors.black]) : null),
            ),
          ),
        ));
  }
}
