import 'package:date_format/date_format.dart' as dateFormat;

export 'package:date_format/date_format.dart';

extension DateExt on DateTime {
  String simpleFormat(List<String> formats) {
    return dateFormat.formatDate(this, formats);
  }
}
