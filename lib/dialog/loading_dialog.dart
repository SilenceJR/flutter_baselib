import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  static bool _loadShowing = false;

  static show(BuildContext context, String content) {
    Navigator.push(
        context,
        PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) {
              return LoadingDialog(content);
            }));
  }

  static dismiss(BuildContext context) {
    if (_loadShowing) {
      Navigator.pop(context);
      _loadShowing = false;
    }
  }

  LoadingDialog(this.content, {this.outsideDismiss = false, this.onBackDismiss = false, this.backgroundColor});

  final String? content;
  final bool outsideDismiss;
  final bool onBackDismiss;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    _loadShowing = true;
    var size = MediaQuery.of(context).size.width * 0.35;
    var themeData = Theme.of(context);
    return WillPopScope(
      onWillPop: () async => Future.value(onBackDismiss),
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (outsideDismiss) {
              dismiss(context);
            }
          },
          child: Center(
            child: Container(
              width: size,
              height: size,
              child: Card(
                color: backgroundColor ?? DialogTheme.of(context).backgroundColor,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(themeData.primaryColor), backgroundColor: Colors.white))),
                      Visibility(
                          visible: null != content && content!.isNotEmpty,
                          child: Center(
                            child: Text(content ?? "",
                                style: TextStyle(color: Colors.white, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
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
