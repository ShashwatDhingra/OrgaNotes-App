import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  MyTextButton(
      {super.key,
      required this.text,
      required this.onPress,
      this.color = Colors.black,
      this.fontSize = 18});

  String text;
  final VoidCallback onPress;
  Color color;
  double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPress,
        child: Text(text,
            style: TextStyle(
              fontFamily: 'Poppin',
                fontWeight: FontWeight.w400, fontSize: fontSize, color: color)));
  }
}
