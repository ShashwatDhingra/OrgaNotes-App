import 'package:flutter/material.dart';
import 'package:organotes/res/my_colors.dart';

class MyTheme {
  static final lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: const AppBarTheme(
          backgroundColor: MyColors.bgColor,
          foregroundColor: Colors.black,
          elevation: 1.3),
      scaffoldBackgroundColor: MyColors.bgColor,
      textTheme: const TextTheme(bodyMedium: TextStyle(fontFamily: 'Rubik')));
}
