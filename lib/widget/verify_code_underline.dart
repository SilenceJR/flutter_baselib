import 'dart:async';

import 'package:baselib/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//下划线 验证码
class VerifyCodeUnderLineWidget extends StatefulWidget {
  final int length;
  final FocusNode editNode;
  final Function(String) callback;
  final Size codeSize;
  final BoxDecoration? decoration;

  VerifyCodeUnderLineWidget({required this.callback, this.length = 6, FocusNode? editNode, this.codeSize = const Size(45, 45), this.decoration})
      : this.editNode = editNode ?? FocusNode();

  @override
  State<StatefulWidget> createState() => _VerifyCodeUnderLineWidgetState();
}

class _VerifyCodeUnderLineWidgetState extends State<VerifyCodeUnderLineWidget> {
  String codeStr = "";

  bool flash = false;

  Timer? _timer;

  void _callback(Timer timer) {
    setState(() {
      flash = !flash;
    });
  }

  @override
  void initState() {
    super.initState();
    if (null == _timer && null == widget.decoration) {
      _timer = Timer.periodic(Duration(milliseconds: 800), (timer) => _callback(timer));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.editNode.hasFocus) {
          Utils.hideKeyboardUnfocus(context);
        } else {
          FocusScope.of(context).requestFocus(widget.editNode);
        }
      },
      child: Stack(
        children: [
          Container(
            width: 0,
            height: 0,
            child: TextField(
              focusNode: widget.editNode,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[\\d]")), LengthLimitingTextInputFormatter(widget.length)],
              keyboardType: TextInputType.number,
              autofillHints: [AutofillHints.oneTimeCode],
              autofocus: true,
              onChanged: (code) {
                if (code.length <= widget.length) {
                  codeStr = code;
                  setState(() {});
                }
                if (codeStr.length >= widget.length) {
                  widget.callback.call(codeStr);
                }
              },
            ),
          ),
          Container(
            width: double.maxFinite,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: _buildCodeRow()),
          )
        ],
      ),
    );
  }

  _buildCodeRow() {
    var list = <Widget>[];
    for (int i = 0; i < widget.length; i++) {
      list.add(_buildCodeItem(i));
    }
    return list;
  }

  Widget _buildCodeItem(int index) => Container(
        width: widget.codeSize.width,
        height: widget.codeSize.height,
        decoration: widget.decoration ??
            BoxDecoration(
                borderRadius: BorderRadius.circular(8), border: index == codeStr.length && flash ? null : Border(bottom: BorderSide(color: Color(0xFF707070)))),
        child:
            Center(child: Text(codeStr.length > index ? codeStr.characters.elementAt(index) : "", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600))),
      );
}
