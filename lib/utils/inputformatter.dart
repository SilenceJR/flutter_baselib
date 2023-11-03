import 'package:characters/characters.dart';
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

class LengthLimitInputFormatter extends TextInputFormatter {
  final int max;

  LengthLimitInputFormatter(this.max) : assert(max > 0, "max length must greater than 0");

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (!newValue.isComposingRangeValid) {
      var newText = newValue.text.characters.toList();
      if (newText.length <= max) {
        return newValue;
      }
      newText = newText.sublist(0, max);
      var txt = newText.join();
      return TextEditingValue(text: txt, selection: TextSelection.collapsed(offset: txt.length));
    }
    return newValue;
  }
}
