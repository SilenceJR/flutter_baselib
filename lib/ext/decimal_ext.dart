import 'package:decimal/decimal.dart';

extension DecimalExt on num {
  Decimal toDecimal() => Decimal.parse("$this");
}
