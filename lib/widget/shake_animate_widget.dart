import 'dart:async';

import 'package:flutter/widgets.dart';

typedef _ShakeAnimateEvent = Function(bool start);

class ShakeAnimateController {
  _ShakeAnimateEvent? _event;

  _setEvent(_ShakeAnimateEvent event) {
    _event = event;
  }

  start() {
    _event?.call(true);
  }

  stop() {
    _event?.call(false);
  }
}

///横向抖动动画
class ShakeAnimateWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final int repeatMillSeconds;
  final ShakeAnimateController controller;

  ShakeAnimateWidget({
    Key? key,
    required this.child,
    required this.controller,
    this.repeatMillSeconds = 1000,
    this.duration = const Duration(milliseconds: 100),
  });

  @override
  State<StatefulWidget> createState() => _ShakeAnimateState();
}

class _ShakeAnimateState extends State<ShakeAnimateWidget> with TickerProviderStateMixin {
  late AnimationController animCl;
  late Animation<double> tween;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    animCl = AnimationController(vsync: this, lowerBound: 0.0, upperBound: 1.0, duration: widget.duration);
    tween = Tween<double>(begin: 0, end: 15).animate(animCl);
    widget.controller._setEvent((s) {
      if (s) {
        if (_timer?.isActive ?? false) {
          _timer?.cancel();
        }
        animCl.repeat(reverse: true);
        _timer = Timer(Duration(milliseconds: widget.repeatMillSeconds), () {
          animCl.stop();
        });
      } else {
        animCl.stop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    animCl.stop();
    animCl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: tween, builder: (c, child) => Transform.translate(offset: Offset(tween.value, 0), child: widget.child));
  }
}
