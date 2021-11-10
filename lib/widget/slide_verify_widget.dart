import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SlideVerifyWidget extends StatefulWidget {
  final Widget icon;
  final Widget verifyIcon;
  final Widget child;
  final Widget? tip;

  final Function(bool)? onVerify;

  const SlideVerifyWidget({Key? key, required this.icon, required this.verifyIcon, required this.child, this.tip, this.onVerify}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SlideVerifyWidgetState();
}

class _SlideVerifyWidgetState extends State<SlideVerifyWidget> with TickerProviderStateMixin {
  final iconSize = 70.0;

  double _iconInitX = 0.0;
  double _iconInitY = 0.0;

  double _verifyIconX = 0.0;
  double _verifyIconY = 0.0;

  double _currentX = 0.0;
  double _currentY = 0.0;

  Offset _endPoint = Offset.zero;

  bool _iconTap = false;

  bool _verified = false;

  bool _showChild = false;

  late Size _boxSize = Size.zero;

  late AnimationController _animationController;
  late Animation<double> animate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _boxSize = context.size ?? Size.zero;
      //计算滑动图标初识位置
      var random = math.Random();
      _currentX = _iconInitX = random.nextInt((_boxSize.width - iconSize).toInt()) + 0.0;
      _currentY = _iconInitY = random.nextInt((_boxSize.height ~/ 3 - iconSize).toInt()) + 0.0;
      //验证的图标位置
      _verifyIconX = (_boxSize.width - iconSize) / 2;
      _verifyIconY = (_boxSize.height * 0.8).toInt() - iconSize;
      setState(() {});
    });
    _animationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_verified) {
          _endPoint = Offset(_verifyIconX, _verifyIconY);
        } else {
          _endPoint = Offset(_iconInitX, _iconInitY);
        }
        _animationController.reset();
        setState(() {
          if (_verified) {
            _showChild = true;
          } else {
            _showChild = false;
          }
          widget.onVerify?.call(_verified);
        });
      }
    });
    animate = Tween<double>(begin: 1, end: 0).animate(_animationController);
    animate.addListener(() {
      if (_verified) {
        _currentX = _verifyIconX + (_endPoint.dx - _verifyIconX) * animate.value;
        _currentY = _verifyIconY + (_endPoint.dy - _verifyIconY) * animate.value;
      } else {
        _currentX = _iconInitX + (_endPoint.dx - _iconInitX) * animate.value;
        _currentY = _iconInitY + (_endPoint.dy - _iconInitY) * animate.value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showChild
        ? widget.child
        : Column(
            children: [
              SizedBox(width: double.infinity, child: widget.tip),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanCancel: () {
                      // _cancel();
                    },
                    onPanEnd: (DragEndDetails details) {
                      //检测是否在校验区内
                      if (_iconTap) {
                        _animationController.forward();
                      }
                    },
                    onPanDown: (DragDownDetails details) {
                      var localPosition = details.localPosition;
                      setState(() {
                        _iconTap = localPosition.dx >= _iconInitX &&
                            localPosition.dx <= _iconInitX + iconSize &&
                            localPosition.dy >= _iconInitY &&
                            localPosition.dy <= _iconInitY + iconSize;
                        if (_iconTap) {
                          _currentX = _iconInitX;
                          _currentY = _iconInitY;
                          _endPoint = Offset(_currentX, _currentY);
                        }
                      });
                    },
                    onPanUpdate: (DragUpdateDetails details) {
                      if (_iconTap) {
                        setState(() {
                          var cX = _currentX + details.delta.dx;
                          var cY = _currentY + details.delta.dy;
                          _currentX = cX <= 0
                              ? 0
                              : cX >= (_boxSize.width - iconSize)
                                  ? (_boxSize.width - iconSize)
                                  : cX;
                          _currentY = cY <= 0
                              ? 0
                              : cY >= (_boxSize.height - iconSize)
                                  ? (_boxSize.height - iconSize)
                                  : cY;
                          _endPoint = Offset(_currentX, _currentY);
                          _checkVerify();
                        });
                      }
                    },
                    child: Stack(
                      children: [
                        Positioned(
                            top: _verifyIconY,
                            left: _verifyIconX,
                            width: iconSize,
                            height: iconSize,
                            child: ColorFiltered(
                                colorFilter: ColorFilter.mode(_verified ? Colors.green : Colors.transparent, _verified ? BlendMode.srcIn : BlendMode.color),
                                child: widget.verifyIcon)),
                        AnimatedBuilder(
                          animation: animate,
                          builder: (context, child) =>
                              // Positioned(top: _iconInitY + _offset.dy, left: _iconInitX + _offset.dx, width: iconSize, height: iconSize, child: widget.icon),
                              Positioned(top: _currentY, left: _currentX, width: iconSize, height: iconSize, child: widget.icon),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  _checkVerify() {
    var xCenter = _currentX + iconSize / 2;
    var yCenter = _currentY + iconSize / 2;
    if (xCenter >= _verifyIconX && xCenter <= (_verifyIconX + iconSize) && yCenter >= _verifyIconY && yCenter <= (_verifyIconY + iconSize)) {
      _verified = true;
    } else {
      _verified = false;
    }
  }
}
