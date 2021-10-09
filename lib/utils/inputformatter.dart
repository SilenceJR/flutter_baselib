import 'package:flutter/services.dart';

class MoneyInputFormatter extends TextInputFormatter {
  late RegExp _moneyRegExp;

  MoneyInputFormatter({int decimal = 2}) : _moneyRegExp = RegExp("\^[0-9]+(.[0-9]{0,$decimal})?\$");

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var oldText = oldValue.text;
    var newText = newValue.text;
    if (oldText.isEmpty && newText.startsWith(".")) {
      newText = "0" + newText;
    }
    if (newText.isNotEmpty && !_moneyRegExp.hasMatch(newText)) {
      newText = oldValue.text;
    }
    return TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }
}
