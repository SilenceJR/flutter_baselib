import 'dart:async';
import 'package:flutter/material.dart';

enum TGravity { TOP, BOTTOM, CENTER }

class _ToastEntry {
  final int duration;

  late OverlayEntry overlayEntry;

  _ToastEntry(String content,
      {gravity = TGravity.CENTER,
      this.duration = Toast.SHORT_LENGTH,
      horizontalOffset = 0,
      verticalOffset = 0}) {
    this.overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
              top: _buildToastPosition(
                  gravity, MediaQuery.of(context).size.height),
              left: 20,
              right: 20,
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalOffset, vertical: verticalOffset),
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 500),
                    child: _buildToastWidget(context, content),
                  ),
                ),
              ),
            ));
  }

  Widget _buildToastWidget(BuildContext context, String content) {
    var light = Theme.of(context).brightness == Brightness.light;
    return Center(
      child: Card(
        color: light
            ? Colors.black.withOpacity(0.7)
            : Colors.white.withOpacity(0.7),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            content,
            style: TextStyle(
                color: light ? Colors.white : Colors.black, fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  double _buildToastPosition(TGravity gravity, double size) {
    switch (gravity) {
      case TGravity.TOP:
        return size / 5;
      case TGravity.BOTTOM:
        return size / 5 * 4;
      case TGravity.CENTER:
        return size / 2 - 10;
      default:
        return size / 2 - 10;
    }
  }
}

class Toast {
  static const SHORT_LENGTH = 2000;
  static const LONG_LENGTH = 4000;

  // static final _toastQueue = <_ToastEntry>[];

  static OverlayEntry? _overlayEntry;

  // static bool _show = false;

  static Timer? _timer;

  static show(BuildContext context, String content,
      {TGravity gravity = TGravity.CENTER,
      int duration = Toast.SHORT_LENGTH,
      double horizontalOffset = 0,
      double verticalOffset = 0}) {
    var tEntry = _ToastEntry(content,
        gravity: gravity,
        duration: duration,
        horizontalOffset: horizontalOffset,
        verticalOffset: verticalOffset);
    _showEntry(context, tEntry);
  }

  static _showEntry(BuildContext context, _ToastEntry tEntry) {
    if (null != _timer && _timer!.isActive) {
      _timer!.cancel();
      _timer = null;
    }
    if (null != _overlayEntry) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    _overlayEntry = tEntry.overlayEntry;
    Overlay.of(context)?.insert(_overlayEntry!);
    _timer = Timer(Duration(milliseconds: tEntry.duration), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

/*
  static show(BuildContext context, String content,
      {TGravity gravity = TGravity.CENTER,
      int duration = Toast.SHORT_LENGTH,
      double horizontalOffset = 0,
      double verticalOffset = 0}) {
    _toastQueue.add(
        _ToastEntry(content, duration: duration, horizontalOffset: horizontalOffset, verticalOffset: verticalOffset));
    if (!_show) {
      _showEntry(context);
    }
  }

  static _showEntry(BuildContext context) {
    if (_toastQueue.isEmpty) {
      _show = false;
      return;
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
    _show = true;
    _timer?.cancel();
    _timer = null;
    var first = _toastQueue.first;
    _toastQueue.remove(first);
    _overlayEntry = first.overlayEntry;
    Overlay.of(context)?.insert(_overlayEntry!);
    _timer = Timer(Duration(milliseconds: first.duration), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _showEntry(context);
    });
  }
  */
}
