import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CheckedBox extends StatelessWidget {
  final double size;
  final bool oval;
  final Color? borderColor;
  final Color? checkColor;
  final bool value;

  CheckedBox({this.value = false, this.size = 20, this.oval = false, this.borderColor, this.checkColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size,
        height: size,
        child: Material(
          color: Colors.transparent,
          borderRadius: oval ? BorderRadius.circular(size / 2.0) : BorderRadius.zero,
          elevation: value ? 2 : 0,
          shadowColor: value ? checkColor : borderColor,
          child: DecoratedBox(
              child: Icon(Icons.done, color: Colors.white, size: size - 2),
              decoration: BoxDecoration(
                shape: oval ? BoxShape.circle : BoxShape.rectangle,
                color: value ? checkColor ?? Theme.of(context).primaryColor : Colors.white,
                border: Border.all(color: value ? checkColor ?? Theme.of(context).primaryColor : borderColor ?? Theme.of(context).primaryColor),
              )),
        ));
  }

  @override
  Widget build1(BuildContext context) {
    return SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
            child: Icon(Icons.done, color: Colors.white, size: size - 2),
            decoration: BoxDecoration(
              shape: oval ? BoxShape.circle : BoxShape.rectangle,
              color: value ? checkColor ?? Theme.of(context).primaryColor : Colors.white,
              border: Border.all(color: value ? checkColor ?? Theme.of(context).primaryColor : borderColor ?? Theme.of(context).primaryColor),
            )));
  }
}
