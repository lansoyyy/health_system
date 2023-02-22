import 'package:flutter/material.dart';
import 'package:sumilao/widgets/text_widget.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String? hint;
  late bool? isObscure;
  final TextEditingController controller;
  final double? width;
  final double? height;
  final int? maxLine;
  final TextInputType? inputType;
  final bool? readOnly;
  final bool? inPassword;

  TextFieldWidget(
      {required this.label,
      this.hint = '',
      required this.controller,
      this.isObscure = false,
      this.width = 300,
      this.height = 40,
      this.maxLine = 1,
      this.readOnly = false,
      this.inPassword = false,
      this.inputType = TextInputType.text});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextRegular(text: widget.label, fontSize: 16, color: Colors.black),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(5)),
          child: TextFormField(
            readOnly: widget.readOnly!,
            keyboardType: widget.inputType,
            decoration: InputDecoration(
              suffixIcon: widget.inPassword!
                  ? IconButton(
                      onPressed: (() {
                        setState(() {
                          widget.isObscure = !widget.isObscure!;
                        });
                      }),
                      icon: widget.isObscure!
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    )
                  : const SizedBox(),
              hintText: widget.hint,
              border: InputBorder.none,
            ),
            maxLines: widget.maxLine,
            obscureText: widget.isObscure!,
            controller: widget.controller,
          ),
        ),
      ],
    );
  }
}
