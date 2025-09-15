import 'package:flutter/material.dart';

class RestartPomodoro extends StatelessWidget {
  final double fontSize;
  final void Function() onPressed;

  const RestartPomodoro({
    super.key,
    required this.fontSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Congratulations!',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
          ),
          SizedBox(height: 18),
          TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateColor.fromMap(
                {
                  WidgetState.any: Color.fromARGB(255, 234, 226, 183),
                }
              )
            ),
            child: Text('Restart',
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black87,
            ),
          ),
          )
        ],
      ),
    );
  }
}