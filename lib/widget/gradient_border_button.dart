
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GradientBorderButton extends StatefulWidget {
  final BorderRadius? borderRadius;
  final double borderWidth;
  final Gradient gradient;
  final Key? key;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final FocusNode? focusNode;
  final bool autofocus;
  final Widget child;
  final Color? color;

  GradientBorderButton({
    this.key,
    required this.onPressed,
    this.onLongPress,
    this.autofocus = false,
    this.focusNode,
    required this.gradient,
    this.borderRadius,
    this.borderWidth = 1,
    this.color = Colors.white,
    required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<GradientBorderButton> {
  var _elevation = 0.0;

  @override
  Widget build(BuildContext context) {
    var buttonTheme = Theme.of(context).buttonTheme;
    var radius = widget.borderRadius ?? (buttonTheme.shape as RoundedRectangleBorder).borderRadius;
    return Semantics(
      button: true,
      container: true,
      enabled: (null != widget.onPressed || null != widget.onLongPress),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: buttonTheme.minWidth.clamp(0, double.infinity), minHeight: buttonTheme.height.clamp(0, double.infinity)),
        child: Ink(
          decoration: BoxDecoration(color: widget.color, borderRadius: radius),
          child: Material(
            type: MaterialType.transparency,
            elevation: (null != widget.onPressed || null != widget.onLongPress) ? _elevation : 2.0,
            borderRadius: radius,
            child: CustomPaint(
              painter: _BorderPainter(widget.gradient, radius as BorderRadius, widget.borderWidth),
              child: InkWell(
                borderRadius: radius,
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
                splashColor: Colors.white38,
                onTap: widget.onPressed,
                highlightColor: Colors.transparent,
                onHighlightChanged: (b) {
                  setState(() {
                    _elevation = b ? 4.0 : 0.0;
                  });
                },
                onLongPress: widget.onLongPress,
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyText2!,
                  child: Center(
                    child: ShaderMask(shaderCallback: (Rect bounds) => widget.gradient.createShader(bounds), child: widget.child),
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

class _BorderPainter extends CustomPainter {
  final Paint _paint = Paint();
  final Gradient gradient;
  final BorderRadius borderRadius;
  final double borderWidth;

  _BorderPainter(this.gradient, this.borderRadius, this.borderWidth);

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    // var outerRRect = RRect.fromRectAndRadius(outerRect,borderRadius);
    var outerRRect = RRect.fromRectAndCorners(outerRect,
        topLeft: borderRadius.topLeft, topRight: borderRadius.topRight, bottomLeft: borderRadius.bottomLeft, bottomRight: borderRadius.bottomRight);
    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(borderWidth, borderWidth, size.width - borderWidth * 2, size.height - borderWidth * 2);
    // var innerRRect = RRect.fromRectAndRadius(innerRect, Radius.circular(borderRadius.x - borderWidth));
    var innerRRect = RRect.fromRectAndCorners(
      innerRect,
      topLeft: Radius.circular(borderRadius.topLeft.x - borderWidth),
      topRight: Radius.circular(borderRadius.topRight.x - borderWidth),
      bottomLeft: Radius.circular(borderRadius.bottomLeft.x - borderWidth),
      bottomRight: Radius.circular(borderRadius.bottomRight.x - borderWidth),
    );

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
