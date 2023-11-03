import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef OptionCall = Future Function(Widget? widget);

class LoadingController {
  OptionCall? _doneCall;
  ValueChanged<double?>? _valueCall;
  ValueChanged<String>? _contentCall;
  VoidCallback? _dismissCall;

  dismiss() => _dismissCall?.call();

  updateValue({double? value}) => _valueCall?.call(value);

  updateContent({required String content}) => _contentCall?.call(content);

  Future done({Widget? widget}) async {
    return await _doneCall?.call(widget);
  }
}

class LoadingDialog extends StatefulWidget {
  ///[value] range [0.0...1.0]
  LoadingDialog(this.content, {this.outsideDismiss = false, this.onBackDismiss = false, this.backgroundColor, this.controller});

  final String? content;
  final bool outsideDismiss;
  final bool onBackDismiss;
  final Color? backgroundColor;
  final LoadingController? controller;

  @override
  State<StatefulWidget> createState() => _LoadingDialogState();

  static show(BuildContext context, String content) {
    Navigator.push(
        context,
        PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) {
              return LoadingDialog(content);
            }));
  }
}

class _LoadingDialogState extends State<LoadingDialog> {
  static bool _loadShowing = false;
  double? pValue;
  Widget? doneWidget;
  String? content;
  bool done = false;

  static dismiss(BuildContext context) {
    if (_loadShowing) {
      Navigator.pop(context);
      _loadShowing = false;
    }
  }

  @override
  void initState() {
    super.initState();
    content = widget.content;
    widget.controller
      ?.._doneCall = (w) {
        done = true;
        doneWidget = w;
        setState(() {});
        return Future.delayed(Duration(milliseconds: 2000), () {
          if (mounted) {
            dismiss(context);
          }
        });
      }
      .._dismissCall = () {
        if (mounted) {
          dismiss(context);
        }
      }
      .._contentCall = (c) {
        content = c;
        setState(() {});
      }
      .._valueCall = (v) {
        done = false;
        pValue = v;
        setState(() {});
      };
  }

  @override
  Widget build(BuildContext context) {
    _loadShowing = true;
    var size = MediaQuery.of(context).size.width * 0.35;
    var themeData = Theme.of(context);
    Widget progressChild;
    if (done) {
      progressChild = doneWidget ?? Icon(Icons.check_circle_rounded);
    } else if (null != pValue) {
      if (pValue! < 1.0) {
        progressChild = CircularProgressIndicator(
            value: pValue,
            valueColor: AlwaysStoppedAnimation(themeData.primaryColor),
            backgroundColor: themeData.primaryColor.withOpacity(0.2));
      } else {
        progressChild = doneWidget ??
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(themeData.primaryColor), backgroundColor: Colors.white);
      }
    } else {
      progressChild = CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(themeData.primaryColor), backgroundColor: Colors.white);
    }
    return WillPopScope(
      onWillPop: () async => Future.value(widget.onBackDismiss),
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (widget.outsideDismiss) {
              dismiss(context);
            }
          },
          child: Center(
            child: Container(
              width: size,
              height: size,
              child: Card(
                color: widget.backgroundColor ?? themeData.dialogTheme.backgroundColor,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Center(child: progressChild)),
                      Visibility(
                          visible: content?.isNotEmpty ?? false,
                          child: Center(
                            child: Text(content ?? "", style: TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
