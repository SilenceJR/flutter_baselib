import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_baselib/baselib.dart';
import 'package:get/get.dart';

import '../ext/extension.dart';

class ToastDialog extends StatefulWidget {
  final bool state;
  final bool? autoDismiss;
  final String content;
  final Duration duration;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  ToastDialog(this.state, this.content,
      {this.duration = const Duration(milliseconds: 2500), this.autoDismiss, this.backgroundColor, this.textStyle});

  @override
  State<StatefulWidget> createState() => _ToastDialogState();
}

class _ToastDialogState extends State<ToastDialog> {
  Timer? _timer;

  @override
  void initState() {
    if (widget.autoDismiss ?? widget.state) {
      _timer = Timer(widget.duration, () => Get.dismiss());
    }
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => Future.value(!widget.state),
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: Center(
            child: Container(
          constraints: BoxConstraints(maxWidth: min(size.width, size.height) * 0.45),
          child: Card(
            color: widget.backgroundColor ?? DialogTheme.of(context).backgroundColor,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: DecoratedBox(
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: widget.state ? Colors.green : Color(0xff666666)),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child:
                            Center(child: Icon(widget.state ? Icons.done : Icons.clear, color: Colors.white, size: 30)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                        child: Text(widget.content, style: widget.textStyle ?? Theme.of(context).textTheme.bodyText2)),
                  )
                ]),
          ),
        )),
      ),
    );
  }
}
