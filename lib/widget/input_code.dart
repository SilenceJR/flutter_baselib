import 'package:flutter/material.dart';

typedef CompleteCallback<String> = Function(String code);

class InputCodeWidget extends StatefulWidget {
  final int length;
  final bool showShade;
  final String shade;
  final String? title;
  final CompleteCallback<String>? callback;

  @override
  State<StatefulWidget> createState() => _InputCodeState();

  InputCodeWidget({this.length = 6, this.showShade = true, this.title, this.shade = "·", this.callback});
}

class _InputCodeState extends State<InputCodeWidget> {
  final List<String> inputChar = <String>[];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.only(bottom: 20),
      child: Material(
        shape: const RoundedRectangleBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(child: Text(widget.title ?? "", style: Theme.of(context).textTheme.subtitle1), margin: EdgeInsets.only(top: 10)),
            _getInputCodeView(context),
            _getInputKeyBoard(context)
          ],
        ),
      ),
    );
  }

  _getInputCodeView(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: _getCodeViewList(context)),
    );
  }

  _getCodeViewList(BuildContext context) {
    var d = (MediaQuery.of(context).size.width - 10 * (widget.length + 1)) / 6.0;
    var list = <Widget>[];
    for (int i = 0; i < widget.length; i++) {
      list.add(Container(
        width: d,
        height: d,
        decoration: BoxDecoration(border: Border.all(color: Color(0xffcccccc))),
        child: Center(
          child: Text(
              inputChar.length > i
                  ? widget.showShade
                      ? widget.shade
                      : inputChar[i]
                  : "",
              style: TextStyle(fontSize: widget.showShade ? 30 : 20, fontWeight: widget.showShade ? FontWeight.bold : FontWeight.normal)),
        ),
      ));
    }
    return list;
  }

  _getInputKeyBoard(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(border: Border.all(color: Color(0xffcccccc), width: 0.5)),
      child: GridView.count(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        children: _getKeyList(context),
        crossAxisSpacing: 0.5,
        mainAxisSpacing: 0.5,
      ),
    );
  }

  _getKeyList(BuildContext context) {
    var list = <Widget>[];
    for (int i = 1; i < 13; i++) {
      list.add(_getItemKey(context, i));
    }
    return list;
  }

  _getItemKey(BuildContext context, int index) {
    switch (index) {
      case 10:
        return SizedBox();
      case 12: //delete
        return Ink(
          child: InkWell(
              onTap: () {
                setState(() {
                  if (inputChar.isNotEmpty) {
                    inputChar.removeLast();
                  }
                });
              },
              child: Center(child: Icon(Icons.backspace_outlined))),
        );
      default:
        return Ink(
          child: InkWell(
            onTap: () {
              setState(() {
                if (inputChar.length < widget.length) {
                  inputChar.add(index == 11 ? "0" : "$index");
                }
                if (inputChar.length >= widget.length) {
                  widget.callback?.call(inputChar.join());
                }
              });
            },
            child: Center(child: Text(index == 11 ? "0" : "$index", style: Theme.of(context).textTheme.subtitle1)),
          ),
        );
    }
  }
}
