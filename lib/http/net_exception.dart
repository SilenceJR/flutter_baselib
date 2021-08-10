import 'package:baselib/constant/lib_config.dart';
import 'package:get/get.dart';

class NetException implements Exception {
  int code;
  String defaultMsg;

  var msgKey = [];

  NetException(this.code, {this.defaultMsg = ""});

  String get message {
    var suffix = LibConfig.degbuEnable ? "_$code" : "";
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
