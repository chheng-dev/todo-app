import 'package:flutter/material.dart';

class TextFielddBuild extends StatelessWidget {
  const TextFielddBuild({
    Key? key,
    required this.hitText,
    required this.txtLable,
    required this.controller,
    required this.suffixIcon,
    required this.readOnly,
  }) : super(key: key);

  final String hitText;
  final String txtLable;
  final TextEditingController controller;
  final Icon suffixIcon;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          txtLable,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: hitText,
              // suffixIcon: suffixIcon,
            ),
            readOnly: readOnly,
          ),
        ),
      ],
    );
  }
}
