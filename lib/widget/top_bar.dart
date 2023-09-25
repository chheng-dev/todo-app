import 'package:flutter/material.dart';
import 'package:todo_app_list/widget/calendar.dart';
import 'package:todo_app_list/widget/create_list.dart';

class TopBarBuild extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  const TopBarBuild({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  State<TopBarBuild> createState() => _TopBarBuildState();
}

class _TopBarBuildState extends State<TopBarBuild> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/menu.png",
                color: Colors.white,
              ),
              SizedBox(width: 8.0),
              Text(
                "Task Todo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                child: InkWell(
                  onTap: () {
                    _showDatePicker(context);
                  },
                  child: Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10),
              CreateTodoList(),
            ],
          )
        ],
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
      setState(() {
        selectedDate = pickedDate;
        widget.onDateSelected(selectedDate);
      });
    }
  }
}
