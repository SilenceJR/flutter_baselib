
import 'package:flutter/material.dart';

extension TextStyleExt on TextStyle {
  TextStyle get medium => this.copyWith(fontWeight: FontWeight.w500);

  TextStyle get medSemiBold => this.copyWith(fontWeight: FontWeight.w600);

  TextStyle get bold => this.copyWith(fontWeight: FontWeight.w700);

  TextStyle setFontWeight(FontWeight fontWeight) => this.copyWith(fontWeight: fontWeight);

  TextStyle setFontSize(double size) => this.copyWith(fontSize: size);

  TextStyle setFontColor(Color color) => this.copyWith(color: color);
}
