import 'dart:async';
import 'dart:developer' as d;

import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// Logger logger = Logger(filter: AppLogFilter(), output: AppLogOutput());

class AppLogFilter extends LogFilter {
  final bool showLog;

  AppLogFilter({required this.showLog});

  @override
  bool shouldLog(LogEvent event) =>
      event.level == Level.error ||
      (showLog && event.level.index >= level!.index);
}

class AppLogOutput extends LogOutput {
  final DateTime? time;
  final int? sequenceNumber;
  final int level;
  final String name;
  final Zone? zone;
  final Object? error;
  final StackTrace? stackTrace;

  AppLogOutput(
      {this.name = '',
      this.time,
      this.sequenceNumber,
      this.zone,
      this.error,
      this.level = 0,
      this.stackTrace});

  @override
  void output(OutputEvent event) {
    event.lines.forEach((e) => d.log(
          e,
          name: name,
          time: time,
          sequenceNumber: sequenceNumber,
          zone: zone,
          error: error,
          level: level,
          stackTrace: stackTrace,
        ));
  }
}
