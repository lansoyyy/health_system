import 'package:flutter/material.dart';
import 'package:sumilao/widgets/text_widget.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final bool? isObscure;
  final TextEditingController controller;
  final double? width;
  final double? height;

  const TextFieldWidget({
    required this.label,
    required this.controller,
    this.isObscure = false,
    this.width = 300,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextRegular(text: label, fontSize: 16, color: Colors.black),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(5)),
          child: TextFormField(
            obscureText: isObscure!,
            controller: controller,
          ),
        ),
      ],
    );
  }
}
