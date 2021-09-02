import 'dart:math';

import 'package:flutter/material.dart';

class AlertActionDialog extends StatelessWidget {
  final Widget? title;
  final Widget? message;

  final String negative;
  final String positive;
  final VoidCallback? negativeCallback;
  final VoidCallback? positiveCallback;
  final Color? backgroundColor;

  AlertActionDialog(
      {this.title, this.message, this.positive = "", this.negative = "", this.negativeCallback, this.positiveCallback, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
            width: min(size.width, size.height) * 0.75,
            child: Card(
              color: backgroundColor ?? DialogTheme.of(context).backgroundColor,
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _getTitle(context),
                    ConstrainedBox(constraints: BoxConstraints(minHeight: 70), child: _getMessage(context)),
                    _buildOption(context)
                  ],
                ),
              ),
            )),
      ),
    );
  }

  _buildOption(BuildContext context) {
    var list = <Widget>[];
    if (negative.isNotEmpty) {
      list.add(Expanded(
        flex: 1,
        child: Container(
          height: 38,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: OutlinedButton(
              onPressed: () {
                if (null != negativeCallback) {
                  negativeCallback?.call();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(negative, style: TextStyle(fontSize: 14))),
        ),
      ));
    }
    if (positive.isNotEmpty) {
      list.add(Expanded(
        flex: 1,
        child: Container(
          height: 38,
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
              onPressed: () {
                if (null != positiveCallback) {
                  positiveCallback?.call();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Text(positive, style: TextStyle(color: Colors.white, fontSize: 14))),
        ),
      ));
    }
    return Visibility(
        visible: list.isNotEmpty,
        child: Container(
            height: 40,
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: list,
            )));
  }

  _getTitle(BuildContext context) {
    return DefaultTextStyle(
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: DialogTheme.of(context).titleTextStyle ?? Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w500),
        child: Container(padding: const EdgeInsets.all(5.0), alignment: Alignment.center, child: title));
  }

  _getMessage(BuildContext context) {
    return DefaultTextStyle(
      style: DialogTheme.of(context).contentTextStyle ?? Theme.of(context).textTheme.bodyText2!,
      child: Container(padding: const EdgeInsets.all(5.0), alignment: Alignment.center, child: message),
    );
  }
}
