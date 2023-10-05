import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_list/src/config/color_constants.dart';
import 'package:todo_app_list/widget/card_report.dart';

class ReportpageWidget extends StatelessWidget {
  const ReportpageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: CardListReport(),
            ),
          ),
        ],
      ),
    );
  }
}
