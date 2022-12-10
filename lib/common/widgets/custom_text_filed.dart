import 'package:flutter/material.dart';
import 'package:sabthok/constants/global_variables.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final inputcolor;
  final bordercolor;
  final String hintText;
  final int? maxLines;
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.inputcolor,
      this.bordercolor,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: inputcolor == null
            ? GlobalVariables.primaryColor.withOpacity(0.7)
            : inputcolor,
      ),
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color:
              bordercolor == null ? GlobalVariables.primaryColor : bordercolor,
          width: 3,
        )),
        // fillColor: GlobalVariables.backgroundColor,
        // filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
            color: GlobalVariables.secondaryColor.withOpacity(0.3),
            fontWeight: FontWeight.w300),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your $hintText';
        }

        return null;
      },
    );
  }
}
