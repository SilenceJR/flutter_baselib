import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CloseEyeTextField extends StatefulWidget {
  final String? hint;
  final bool showClearIcon;

  //最后面长显icon
  final bool showHideIcon;

  //closeIcon
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final double? textFieldHeight;
  final TextBaseline? textBaseline;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextAlign? textAlign;
  final bool autofocus;
  final bool readOnly;
  final double? cursorWidth;
  final Radius? cursorRadius;
  final bool centerVertical;
  final StrutStyle? strutStyle;
  final int? maxLines;

  CloseEyeTextField(
      {Key? key,
      this.hint,
      this.showClearIcon = true,
      this.showHideIcon = false,
      this.readOnly = false,
      this.prefixIcon,
      this.suffixIcon,
      //  隐藏 文字 以 密码形式显示
      this.obscureText,
      required this.controller,
      this.inputFormatters,
      this.autofillHints,
      this.textInputAction,
      this.keyboardType,
      this.onSubmitted,
      this.onChanged,
      this.focusNode,
      this.textFieldHeight,
      this.style,
      this.hintStyle,
      this.textAlign,
      this.autofocus = false,
      this.textBaseline,
      this.cursorWidth,
      this.cursorRadius,
      this.centerVertical = true,
      this.strutStyle,
      this.maxLines = 1,
      this.crossAxisAlignment = CrossAxisAlignment.center})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CloseEyeTextField> {
  bool _obscureText = false;
  late FocusNode _focusNode;
  bool _hasFocus = false;
  double? _height;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? (widget.showHideIcon && null == widget.suffixIcon);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {
        _height = context.size?.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _style = widget.style ?? Theme.of(context).textTheme.bodyText2;
    var _textPainterHeight = (TextPainter(
            textWidthBasis: TextWidthBasis.longestLine,
            text: TextSpan(text: '', style: _style),
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .height;
    return SizedBox(
      height: widget.textFieldHeight,
      child: Row(
        textBaseline: widget.textBaseline,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: [
          Visibility(visible: null != widget.prefixIcon, child: Center(child: widget.prefixIcon)),
          Expanded(
              child: TextField(
                  style: _style,
                  controller: widget.controller,
                  maxLines: widget.maxLines,
                  autofocus: widget.autofocus,
                  cursorRadius: widget.cursorRadius ?? Radius.circular(1.5),
                  cursorWidth: widget.cursorWidth ?? 1.5,
                  readOnly: widget.readOnly,
                  focusNode: _focusNode,
                  strutStyle: widget.strutStyle,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: widget.keyboardType,
                  autofillHints: widget.autofillHints,
                  onSubmitted: widget.onSubmitted,
                  onChanged: widget.onChanged,
                  textAlign: widget.textAlign ?? TextAlign.start,
                  textInputAction: widget.textInputAction ?? TextInputAction.done,
                  obscureText: _obscureText,
                  inputFormatters: widget.inputFormatters,
                  cursorHeight: _textPainterHeight,
                  decoration: InputDecoration(
                      hintStyle: widget.hintStyle ??
                          (Theme.of(context).inputDecorationTheme.hintStyle ?? _style)?.copyWith(color: Theme.of(context).hintColor),
                      hintText: widget.hint,
                      isDense: true,
                      isCollapsed: true,
                      contentPadding: (null != _height && widget.centerVertical)
                          ? EdgeInsets.symmetric(vertical: (_height! - _textPainterHeight) / 2)
                          : null,
                      border: InputBorder.none))),
          Visibility(visible: widget.showClearIcon && _hasFocus, child: _clearIcon()),
          Visibility(visible: widget.showHideIcon, child: widget.suffixIcon ?? _hideSuffixIcon(context))
        ],
      ),
    );
  }

  _clearIcon() {
    return Container(
        child: GestureDetector(onTap: () => widget.controller.clear(), child: Icon(Icons.cancel, size: 20, color: Colors.grey)));
  }

  _hideSuffixIcon(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
            onTap: () => setState(() {
                  _obscureText = !_obscureText;
                }),
            child: Icon(_obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: Colors.grey, size: 20)));
  }
}
