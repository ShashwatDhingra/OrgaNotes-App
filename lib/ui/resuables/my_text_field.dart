import 'dart:io';

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    this.label,
    this.textInputType,
    this.enable,
    required this.controller,
    this.prefixIcon,
    this.maxLines,
    this.isPassword,
    this.suffixIcon,
    this.hintText,
    this.maxLength,
    this.filledColor = const Color(0xFFF0F1F3),
    this.lineColor = const Color(0xFFF0F1F3),
    this.validator
  });

  final String? label;
  final String? hintText;
  final TextInputType? textInputType;
  final bool? enable;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isPassword;
  final int? maxLines;
  final int? maxLength;
  final Color filledColor;
  final Color lineColor;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      keyboardType: textInputType,
      validator: validator,
      obscureText: isPassword ?? false,
      decoration: InputDecoration(
          fillColor: filledColor,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1)),
              disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: lineColor, width: 2)),),
      controller: controller,
      enabled: enable,
    );
  }
}
