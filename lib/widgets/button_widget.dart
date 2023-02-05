import 'package:flutter/material.dart';
import 'package:sumilao/widgets/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? color;

  const ButtonWidget(
      {required this.label,
      required this.onPressed,
      this.width = 300,
      this.height = 50,
      this.color = const Color(0xff339655)});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        minWidth: width,
        height: height,
        color: color,
        onPressed: onPressed,
        child: TextRegular(text: label, fontSize: 18, color: Colors.white));
  }
}
