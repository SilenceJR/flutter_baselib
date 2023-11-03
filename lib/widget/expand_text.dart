import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandText extends StatefulWidget {
  final InlineSpan data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  ExpandText(this.data,
      {Key? key,
      this.style,
      this.strutStyle,
      this.textAlign,
      this.textDirection = TextDirection.ltr,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaleFactor,
      required this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpandTextState();
}

class _ExpandTextState extends State<ExpandText> {
  bool _expand = false;
  Size? _size;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _size = context.size;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    /*var eP = TextPainter(
        text: _getExpandText(),
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign ?? TextAlign.start,
        textDirection: widget.textDirection,
        textScaleFactor: widget.textScaleFactor ?? 1.0,
        locale: widget.locale,
        textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
        textHeightBehavior: widget.textHeightBehavior)
      ..layout();*/
    var painter = TextPainter(
        text: widget.data,
        maxLines: widget.maxLines,
        textAlign: widget.textAlign ?? TextAlign.start,
        textDirection: widget.textDirection,
        textScaleFactor: widget.textScaleFactor ?? 1.0,
        locale: widget.locale,
        strutStyle: widget.strutStyle,
        textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
        textHeightBehavior: widget.textHeightBehavior);
    if (null != _size) {
      painter.layout(maxWidth: _size!.width);
      if (painter.didExceedMaxLines) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_getText(), Align(alignment: Alignment.centerRight, child: Text.rich(_getExpandText()))],
        );
      } else {
        return _getText();
      }
    } else {
      return _getText();
    }
  }

  Text _getText() => Text.rich(widget.data,
      style: widget.style,
      maxLines: _expand ? null : widget.maxLines,
      textAlign: widget.textAlign ?? TextAlign.start,
      textDirection: widget.textDirection,
      textScaleFactor: widget.textScaleFactor ?? 1.0,
      locale: widget.locale,
      softWrap: widget.softWrap ?? true,
      overflow: _expand ? null : TextOverflow.ellipsis,
      strutStyle: widget.strutStyle,
      textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: widget.textHeightBehavior);

  WidgetSpan _getExpandText() => WidgetSpan(
          child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _expand = !_expand;
          setState(() {});
        },
        child: Icon(_expand ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down, size: 20, color: Theme.of(context).primaryColor),
      ));
/*TextSpan(
      text: _expand ? "收起" : "展开",
      style: widget.style?.copyWith(color: Theme.of(context).primaryColor),
      locale: widget.locale,
      recognizer: recognizer)*/
}
