import 'dart:developer' as d;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

Logger logger = Logger(filter: AppLogFilter(), output: AppLogOutput());

class AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) =>
      event.level == Level.error ||
      (!kReleaseMode && event.level.index >= level!.index);
}

class AppLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach((e) => d.log(e));
  }
}
