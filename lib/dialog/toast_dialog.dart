import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../ext/extension.dart';

class ToastDialog extends StatelessWidget {
  final bool state;
  final String content;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  ToastDialog(this.state, this.content, {this.backgroundColor, this.textStyle}) {
    if (state) {
      Timer(Duration(milliseconds: 2500), () {
        Get.dismiss();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return Future.value(!state);
      },
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: Center(
            child: Container(
          constraints: BoxConstraints(maxWidth: min(size.width, size.height) * 0.45),
          child: Card(
            color: backgroundColor ?? DialogTheme.of(context).backgroundColor,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: DecoratedBox(
                      decoration: BoxDecoration(shape: BoxShape.circle, color: state ? Colors.green : Color(0xff666666)),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(child: Icon(state ? Icons.done : Icons.clear, color: Colors.white, size: 30)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(child: Text(content, style: textStyle ?? Theme.of(context).textTheme.bodyText2)),
                  )
                ]),
          ),
        )),
      ),
    );
  }
}
