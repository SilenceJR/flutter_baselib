import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebDialog extends StatefulWidget {
  final String url;
  final String? title;
  final bool auth;
  final Color? backgroundColor;

  WebDialog(this.url, {this.title, this.auth = false, this.backgroundColor});

  @override
  State<StatefulWidget> createState() => _WebState();
}

class _WebState extends State<WebDialog> {
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
          color: widget.backgroundColor,
          margin: EdgeInsets.zero,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(widget.title ?? title ?? "", style: Theme.of(context).textTheme.subtitle1))),
                Container(
                    height: 4,
                    child: show
                        ? LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                          )
                        : null),
                Expanded(
                  child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: widget.url,
                    onWebViewCreated: (c) {
                      controller = c;
                    },
                    onPageStarted: (url) {
                      _getTitle();
                      setState(() {
                        show = true;
                      });
                    },
                    onPageFinished: (url) {
                      _getTitle();
                      setState(() {
                        show = false;
                      });
                    },
                    onProgress: (p) {
                      setState(() {
                        progress = p / 100.0;
                      });
                    },
                  ),
                ),
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
                                child: Text("reject".tr)),
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
                                child: Text("agree".tr + (_downTime.value == 0 ? "" : "(${_downTime.value.toInt()}S)")))))
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

  _getTitle() {
    controller?.getTitle().then((value) {
      setState(() {
        title = value;
      });
    });
  }
}
