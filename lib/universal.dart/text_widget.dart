import 'package:batnf/constants.dart/app_colors.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {super.key,
      required this.text,
      this.fontSize = 16,
      this.fontWeight = FontWeight.normal,
      this.color = AppColors.titleBlack,
      this.textAlign,
      this.height});
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign? textAlign;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          height: height,
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize,
          fontFamily: "Behalal"),
    );
  }
}
