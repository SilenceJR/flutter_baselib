import 'package:get/get.dart';

import '../lib_config.dart';

abstract class NetException implements Exception {
  int code;
  String defaultMsg;

  NetException(this.code, {this.defaultMsg = ""});

  String get message;
}
