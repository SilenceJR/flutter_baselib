import 'package:flutter/material.dart';

class IconCheckedBox extends StatelessWidget {
  final Widget checkedIcon;
  final Widget icon;
  final bool value;

  IconCheckedBox(
      {Key? key,
      this.value = false,
      this.checkedIcon = const Icon(Icons.check_circle_outline, size: 20),
      this.icon = const Icon(Icons.circle_outlined, size: 20)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: icon,
        secondChild: checkedIcon,
        crossFadeState:
            value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 300));
  }
}
