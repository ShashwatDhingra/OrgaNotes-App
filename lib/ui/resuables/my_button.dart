import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:organotes/utils/screen_size.dart';

class MyButton extends StatelessWidget {
  MyButton({super.key, required this.text, required this.onPress, required this.color, this.isLoading = false});

  final String text;
  final VoidCallback onPress;
  final Color color;
  final bool isLoading;
  final scWidth = ScreenSize.screenWidth;
  final scHeight = ScreenSize.screenHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(36.0)),
        padding: const EdgeInsets.all(12.0),
        width: scWidth * 0.9,
        child: Center(
            child: isLoading ? const SpinKitFadingCircle(color: Colors.white, size: 18) : Text(text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400))),
      ),
    );
  }
}
