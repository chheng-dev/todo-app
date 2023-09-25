import 'package:flutter/material.dart';

void main() {
  runApp(const CalendarBuild());
}

class CalendarBuild extends StatelessWidget {
  const CalendarBuild({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          _showDatePicker(context);
        },
        child: Icon(
          Icons.calendar_month,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      debugPrint('Date picked: ${pickedDate}');
    }
  }
}
