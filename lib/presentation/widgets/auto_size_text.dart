import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomAutoSizeText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  const CustomAutoSizeText(this.text, this.style, this.textAlign, {super.key});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      textAlign: textAlign,
      style: style,
      minFontSize: 0,
      maxLines: null,
      overflow: TextOverflow.fade,
    );
  }
}
