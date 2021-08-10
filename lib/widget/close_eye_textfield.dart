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
  final Decoration? decoration;
  final Iterable<String>? autofillHints;

  final TextInputAction? textInputAction;

  final TextInputType? keyboardType;

  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  final EdgeInsets? decorationPadding;

  final FocusNode? focusNode;

  final double? textFieldHeight;
  final TextBaseline? textBaseline;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool autofocus;
  final bool readOnly;

  CloseEyeTextField(
      {this.hint,
      this.showClearIcon = true,
      this.showHideIcon = false,
      this.readOnly = false,
      this.prefixIcon,
      this.suffixIcon,
      //  隐藏 文字 以 密码形式显示
      this.obscureText,
      required this.controller,
      this.inputFormatters,
      this.decoration,
      this.autofillHints,
      this.textInputAction,
      this.keyboardType,
      this.onSubmitted,
      this.onChanged,
      this.decorationPadding,
      this.focusNode,
      this.textFieldHeight,
      this.style,
      this.hintStyle,
      this.autofocus = false,
      this.textBaseline,
      this.crossAxisAlignment = CrossAxisAlignment.center});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CloseEyeTextField> {
  bool _obscureText = false;
  FocusNode? _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? (widget.showHideIcon && null == widget.suffixIcon);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode?.addListener(() {
      setState(() {
        _hasFocus = _focusNode!.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _style = widget.style ?? TextStyle(fontSize: 14, color: Color(0xff333333));
    return Container(
      height: widget.textFieldHeight ?? 36,
      decoration: widget.decoration,
      alignment: Alignment.center,
      child: Row(
        textBaseline: widget.textBaseline,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: [
          Visibility(visible: null != widget.prefixIcon, child: Container(child: widget.prefixIcon)),
          Expanded(
            child: TextField(
              style: _style,
              controller: widget.controller,
              maxLines: 1,
              autofocus: widget.autofocus,
              cursorRadius: Radius.circular(2),
              cursorWidth: 1.5,
              readOnly: widget.readOnly,
              focusNode: _focusNode,
              textAlignVertical: TextAlignVertical.top,
              keyboardType: widget.keyboardType,
              autofillHints: widget.autofillHints,
              onSubmitted: widget.onSubmitted,
              onChanged: widget.onChanged,
              textAlign: TextAlign.start,
              textInputAction: widget.textInputAction ?? TextInputAction.done,
              obscureText: _obscureText,
              inputFormatters: widget.inputFormatters,
              decoration: InputDecoration(
                  hintStyle: widget.hintStyle ?? _style.copyWith(color: Theme.of(context).hintColor),
                  hintText: widget.hint,
                  isDense: true,
                  border: InputBorder.none),
            ),
          ),
          Visibility(visible: _hasFocus, child: _clearIcon()),
          Visibility(visible: widget.showHideIcon, child: widget.suffixIcon ?? _hideSuffixIcon(context))
        ],
      ),
    );
  }

  _clearIcon() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () => widget.controller.clear(),
        child: Icon(Icons.cancel, size: 20, color: Colors.grey),
      ),
    );
  }

  _hideSuffixIcon(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () => setState(() {
          _obscureText = !_obscureText;
        }),
        child: Icon(_obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash, color: Colors.grey, size: 20),
      ),
    );
  }
}
