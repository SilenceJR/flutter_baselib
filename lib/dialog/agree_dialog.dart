import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AgreeDialog extends StatefulWidget {
  final String? title;
  final bool auth;
  final String rejectButton;
  final String agreeButton;

  final Widget? child;

  AgreeDialog({this.title, this.auth = false, this.child, this.rejectButton = "reject", this.agreeButton = "agree"});

  @override
  State<StatefulWidget> createState() => _AgreeDialogState();
}

class _AgreeDialogState extends State<AgreeDialog> {
  bool show = false;
  double progress = 0.0;

  final _downTime = 5000.0.obs;

  WebViewController? controller;
  String? title = "";
  final _timer = TimerUtil(mInterval: 1000, mTotalTime: 5000);

  @override
  void initState() {
    super.initState();
    _timer.setOnTimerTickCallback((millisUntilFinished) => _downTime.value = millisUntilFinished / 1000);
    if (widget.auth) {
      _timer.startCountDown();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Card(
          margin: EdgeInsets.zero,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              children: [
                Container(padding: EdgeInsets.all(5), child: Center(child: Text(widget.title ?? title ?? "", style: Theme.of(context).textTheme.subtitle1))),
                Expanded(child: Container(child: widget.child)),
                Visibility(
                  visible: widget.auth,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 16, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(Color(0xFF999999), BlendMode.srcIn),
                            child: OutlinedButton(
                                onPressed: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context, false);
                                  }
                                },
                                child: Text(widget.rejectButton)),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                            child: Obx(() => ElevatedButton(
                                onPressed: _downTime.value == 0
                                    ? () {
                                        if (Navigator.canPop(context)) {
                                          Navigator.pop(context, true);
                                        }
                                      }
                                    : null,
                                child: Text(widget.agreeButton + (_downTime.value == 0 ? "" : "(${_downTime.value.toInt()}S)")))))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
