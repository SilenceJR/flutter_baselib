import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baselib/utils/inputformatter.dart';

//下划线 验证码
class VerifyCodeUnderLineWidget extends StatefulWidget {
  final int length;
  final FocusNode editNode;
  final Function(String) callback;
  final Size codeSize;
  final bool showCursor;
  final BoxDecoration? decoration;

  VerifyCodeUnderLineWidget(
      {required this.callback,
      this.length = 6,
      this.showCursor = true,
      FocusNode? editNode,
      this.codeSize = const Size(45, 45),
      this.decoration})
      : this.editNode = editNode ?? FocusNode();

  @override
  State<StatefulWidget> createState() => _VerifyCodeUnderLineWidgetState();
}

class _VerifyCodeUnderLineWidgetState extends State<VerifyCodeUnderLineWidget> {
  String codeStr = "";

  bool flash = false;

  bool call = false;

  Timer? _timer;

  late TextEditingController _editController;

  void _callback(Timer timer) {
    setState(() {
      flash = !flash;
    });
  }

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController();
    _timer?.cancel();
    if (widget.showCursor) {
      _timer = Timer.periodic(Duration(milliseconds: 500), (timer) => _callback(timer));
    }
    _editController.addListener(() {
      codeStr = _editController.text;
      if (codeStr.length < widget.length) {
        call = false;
      }
      if (codeStr.length >= widget.length && !call) {
        call = true;
        widget.callback.call(codeStr);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            width: 0,
            height: 0,
            child: TextField(
                controller: _editController,
                focusNode: widget.editNode,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[0-9]")), LengthLimitInputFormatter(widget.length)],
                keyboardType: TextInputType.number,
                autofillHints: [AutofillHints.oneTimeCode],
                autofocus: true)),
        Container(
          width: double.maxFinite,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: _buildCodeRow()),
        )
      ],
    );
  }

  _buildCodeRow() {
    var list = <Widget>[];
    for (int i = 0; i < widget.length; i++) {
      list.add(_buildCodeItem(i));
    }
    return list;
  }

  Widget _buildCodeItem(int index) => GestureDetector(
        onTap: () {
          if (!widget.editNode.hasFocus) {
            widget.editNode.requestFocus();
          }
        },
        child: Container(
          width: widget.codeSize.width,
          height: widget.codeSize.height,
          decoration: widget.decoration,
          child: Stack(
            children: [
              Center(
                  child: Text(codeStr.length > index ? codeStr.characters.elementAt(index) : "",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600))),
              Visibility(
                visible: widget.showCursor,
                child: Positioned(
                    bottom: widget.codeSize.width * 0.3,
                    left: widget.codeSize.width * 0.3,
                    right: widget.codeSize.width * 0.3,
                    child: Container(
                        height: 2,
                        decoration: index == codeStr.length && flash
                            ? BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(2))
                            : null)),
              ),
            ],
          ),
        ),
      );
}
