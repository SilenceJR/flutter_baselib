import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnCompleteCallback = Function(String char);

typedef CharInputChildBuilder = Function(BuildContext context, int index, bool selected, String char);

//验证码输入
class CharInputTextField extends StatefulWidget {
  final textInputType;
  final focusNode = FocusNode();
  final int length;
  final controller = TextEditingController();

  final CharInputChildBuilder childBuilder;

  final ValueChanged<String>? onChanged;

  CharInputTextField(
      {Key? key,
      required this.childBuilder,
      this.length = 6,
      defaultChar = "",
      this.textInputType = TextInputType.text,
      this.onChanged})
      : super(key: key) {
    controller.text = defaultChar;
  }

  @override
  State<StatefulWidget> createState() => CharTextFieldState(inputChars: controller.text);
}

class CharTextFieldState extends State<CharInputTextField> {
  var inputChars;

  CharTextFieldState({this.inputChars = ""});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!widget.focusNode.hasFocus) {
          widget.focusNode.requestFocus();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          TextField(
            focusNode: widget.focusNode,
            controller: widget.controller,
            keyboardType: widget.textInputType,
            maxLines: 1,
            cursorWidth: 0,
            onChanged: (s) {
              widget.onChanged?.call(s);
              setState(() {
                inputChars = s;
              });
            },
            textInputAction: TextInputAction.done,
            enableInteractiveSelection: false,
            style: TextStyle(color: Colors.transparent),
            inputFormatters: [LengthLimitingTextInputFormatter(widget.length)],
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _getItems(context),
          )
        ],
      ),
    );
  }

  _getItems(BuildContext context) {
    var list = <Widget>[];
    for (int i = 0; i < widget.length; i++) {
      list.add(widget.childBuilder(context, i, inputChars.length == i, inputChars.length > i ? inputChars[i] : ""));
    }
    return list;
  }
}
/*

class CharTextFieldPainter extends CustomPainter {
  final int length;

  final double minSpace;
  final Radius radius;

  final EdgeInsets padding;

  final Paint mPaint = Paint()..isAntiAlias = true;

  var inputChars = "";

  CharTextFieldPainter({this.length = 6, this.minSpace = 10, this.radius = Radius.zero, this.padding,this.inputChars}) {
    mPaint.color = Colors.redAccent;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

  @override
  void paint(Canvas canvas, Size size) {
    mPaint.strokeWidth = 1.0;
    mPaint.style = PaintingStyle.stroke;
    // var d = size.width / (length + 1).toDouble();
    //剩余宽度
    var w = size.width - (length + 1) * minSpace;
    //计算最小宽度
    var minWidth = min(w / 6.0, size.height);
    //计算横向 间距
    var hSpace = (size.width - minWidth * length) / ((length + 1).toDouble());
    //纵向间距
    print("minWidth:$minWidth,hSpace:$hSpace");
    var vSpace = (size.height - minWidth) / 2.0;
    for (var i = 0; i < length; i++) {
      double top = vSpace;
      double left = (i + 1) * hSpace + minWidth * i;
      double right = left + minWidth;
      double bottom = top + minWidth;
      canvas.drawRRect(RRect.fromLTRBR(left, top, right, bottom, radius), mPaint);
    }
  }
}
*/
