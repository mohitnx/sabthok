import 'package:flutter/material.dart';
import 'package:sabthok/constants/global_variables.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String text;
  //text, onTAp is required, color not required, if not provided, it will take default themem color(orangeish)
  final Color? color;
  final VoidCallback onTap;
  const CustomPrimaryButton(
      {super.key, this.color, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      //cant use const Text(text) as value of text won't be known at compile time, it will only be known at runtime

      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(
          290,
          60,
        ),
      ),
      child: Text(
        text,
        //if color of button not provided(null), then set color for text as white otherwise set color of text as black
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}

class CustomSecondaryButton extends StatelessWidget {
  final String text;

  final Color? color;
  final Color? textColor;
  final VoidCallback onTap;
  const CustomSecondaryButton(
      {super.key,
      this.textColor,
      this.color,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      //cant use const Text(text) as value of text won't be known at compile time, it will only be known at runtime

      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      child: Text(
        text,
        //if color of button not provided(null), then set color for text as white otherwise set color of text as black
        style: TextStyle(
          color: textColor == null
              ? GlobalVariables.primaryColor.withOpacity(0.4)
              : textColor,
          fontSize: 18,
        ),
      ),
    );
  }
}
