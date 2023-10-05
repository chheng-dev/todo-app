import 'package:flutter/material.dart';

class TopBarBuild extends StatelessWidget {
  const TopBarBuild({
    Key? key,
    required this.formattedDate,
  }) : super(key: key);

  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Text(
      formattedDate,
      style: TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'KantumruyPro',
      ),
    );
  }
}
