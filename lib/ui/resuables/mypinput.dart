import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class MyPinPut extends StatelessWidget {
  MyPinPut({super.key, required this.onSave});

  final Function(String) onSave;

  final defaultTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w200),
  decoration: BoxDecoration(
    border: Border.all(color: Color.fromRGBO(218, 219, 220, 1)),
    borderRadius: BorderRadius.circular(8),
  ),
);

final focusedPinTheme =
PinTheme(
  width: 56,
  height: 56,
  textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w200),
  decoration: BoxDecoration(
    border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
    borderRadius: BorderRadius.circular(8),
  ),
);

  @override
  Widget build(BuildContext context) {
    return Pinput(
      defaultPinTheme: defaultTheme,
      focusedPinTheme: focusedPinTheme,
      onCompleted: onSave
    );
  }
}