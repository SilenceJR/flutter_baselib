import 'package:flutter/services.dart';

class MoneyInputFormatter extends TextInputFormatter {
  late RegExp _moneyRegExp;

  MoneyInputFormatter({int decimal = 2}) {
    // _moneyRegExp=RegExp("^([1-9][0-9]*)+(.[0-9]{0,$decimal})?\$");
    _moneyRegExp = RegExp("^[0-9]+(.[0-9]{0,$decimal})?\$");
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (text.isNotEmpty) {
      try {
        if (text.length > 1 && double.parse(text) == 0.0) {
          text = "0";
        }
      } catch (e) {}
      if (text.startsWith(".")) {
        text = "0" + text;
      }
      if (!_moneyRegExp.hasMatch(text)) {
        text = oldValue.text;
      }
    }
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}
