import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatelessWidget {
  final Function(String) onDateSelected;
  DatePickerWidget(this.onDateSelected);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(),
      onPressed: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          onDateSelected(DateFormat.yMd().format(picked));
        } else {
          onDateSelected("");
        }
      },
      child: Icon(Icons.calendar_month),
    );
  }
}
