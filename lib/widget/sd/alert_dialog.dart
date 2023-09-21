import 'package:flutter/material.dart';
import 'package:todo_app_list/src/config/color_constants.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  CustomAlertDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorConstants.primary,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onConfirm,
          child: Text(
            'បាទ/ចាស',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
