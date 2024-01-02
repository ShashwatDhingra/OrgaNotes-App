import 'package:flutter/cupertino.dart';

class ScreenSize{
  static late double screenWidth;
  static late double screenHeight;

  void init(BuildContext context){
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
}