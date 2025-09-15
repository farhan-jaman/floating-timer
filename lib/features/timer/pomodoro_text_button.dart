import 'package:flutter/material.dart';

class PomodoroTextButton extends StatelessWidget {
  final void Function() onTap;
  final bool isFocused;
  final String text;
  final double fontSize;

  const PomodoroTextButton({
    super.key,
    required this.onTap,
    required this.isFocused,
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isFocused ? Color.fromARGB(255, 234, 226, 183) : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}