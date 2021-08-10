import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final Key? key;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final FocusNode? focusNode;
  final bool autofocus;
  final Widget child;
  final Gradient? gradient;
  final BorderRadius? borderRadius;

  GradientButton(
      {this.key,
      required this.onPressed,
      this.onLongPress,
      this.focusNode,
      this.autofocus = false,
      required this.child,
      required this.gradient,
      this.borderRadius});

  @override
  State<StatefulWidget> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  var _elevation = 2.0;

  @override
  Widget build(BuildContext context) {
    var buttonTheme = Theme.of(context).buttonTheme;
    return Semantics(
      button: true,
      container: true,
      enabled: (null != widget.onPressed || null != widget.onLongPress),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: buttonTheme.minWidth.clamp(0, double.infinity),
          minHeight: buttonTheme.height.clamp(0, double.infinity),
        ),
        child: Material(
          elevation: (null != widget.onPressed || null != widget.onLongPress) ? _elevation : 0.0,
          borderRadius: widget.borderRadius ?? (buttonTheme.shape as RoundedRectangleBorder).borderRadius,
          child: Ink(
            decoration: BoxDecoration(
                borderRadius: widget.borderRadius ?? (buttonTheme.shape as RoundedRectangleBorder).borderRadius,
                gradient: (null != widget.onPressed || null != widget.onLongPress) ? widget.gradient : null,
                color: null == widget.onPressed && null == widget.onLongPress ? Theme.of(context).disabledColor : null,
                shape: BoxShape.rectangle),
            child: InkWell(
              borderRadius: widget.borderRadius ?? (buttonTheme.shape as RoundedRectangleBorder).borderRadius as BorderRadius,
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
              splashColor: Colors.white38,
              highlightColor: Colors.transparent,
              onTap: widget.onPressed,
              onHighlightChanged: (b) {
                setState(() {
                  _elevation = b ? 4.0 : 2.0;
                });
              },
              onLongPress: widget.onLongPress,
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontSize: 14),
                child: Center(
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
