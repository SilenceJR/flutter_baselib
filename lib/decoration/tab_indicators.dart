//可固定长度 圆角
import 'package:flutter/material.dart';

class FixedUnderlineTabIndicator extends Decoration {
  final Color color;
  final double radius;
  final double? indicatorWidth;
  final double indicatorHeight;

  FixedUnderlineTabIndicator({required this.color, this.radius = 2, this.indicatorWidth, this.indicatorHeight = 2});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _TabUnderlinePainter(this, onChanged);

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is FixedUnderlineTabIndicator) {
      return FixedUnderlineTabIndicator(
        radius: a.radius + (a.radius - this.radius) * t,
        indicatorWidth: (null != a.indicatorWidth && null != this.indicatorWidth)
            ? a.indicatorWidth! + (a.indicatorWidth! - this.indicatorWidth!) * t
            : null,
        indicatorHeight: a.indicatorHeight + (a.indicatorHeight - this.indicatorHeight) * t,
        color: Color.lerp(a.color, this.color, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is FixedUnderlineTabIndicator) {
      return FixedUnderlineTabIndicator(
        radius: this.radius + (b.radius - this.radius) * t,
        indicatorWidth: (null != b.indicatorWidth && null != this.indicatorWidth)
            ? this.indicatorWidth! + (b.indicatorWidth! - this.indicatorWidth!) * t
            : null,
        indicatorHeight: this.indicatorHeight + (b.indicatorHeight - this.indicatorHeight) * t,
        color: Color.lerp(this.color, b.color, t)!,
      );
    }
    return super.lerpTo(b, t);
  }
}

class _TabUnderlinePainter extends BoxPainter {
  final FixedUnderlineTabIndicator indicator;
  final Paint _paint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  _TabUnderlinePainter(this.indicator, VoidCallback? onChanged) : super(onChanged) {
    _paint.color = indicator.color;
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    var size = configuration.size!;
    var top = size.height - offset.dy - indicator.indicatorHeight;
    var indicatorWidth = indicator.indicatorWidth;
    double left;
    double right;
    if (null == indicatorWidth) {
      left = offset.dx;
      right = offset.dx + size.width;
    } else {
      var d = (indicatorWidth - size.width) / 2;
      left = offset.dx - d;
      right = offset.dx + d + size.width;
    }
    var bottom = size.height - offset.dy;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(left, top, right, bottom), Radius.circular(indicator.radius)), _paint);
  }
}
