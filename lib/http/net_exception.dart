import 'package:get/get.dart';

import '../lib_config.dart';

abstract class NetExceptionMixin implements Exception {
  int code;
  String defaultMsg;

  NetExceptionMixin(this.code, {this.defaultMsg = ""});

  String get message;
}

class NetExceptionDefault extends NetExceptionMixin implements Exception {

  NetExceptionDefault(int code, {String defaultMsg = ""}) : super(code, defaultMsg: defaultMsg);

  @override
  String get message => _getMsg();

  String _getMsg() {
    var suffix = LibConfig.delegate.debugEnable ? "_$code" : "";
    var trCode = "net_code_$code";
    var tr = trCode.tr;
    if (tr == trCode) {
      if (defaultMsg.isNotEmpty) {
        tr = defaultMsg;
      } else {
        //未找到翻译
        tr = "default_net_error".tr;
      }
    }
    return "$tr$suffix";
  }
}
