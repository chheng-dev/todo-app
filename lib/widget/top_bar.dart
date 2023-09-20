import 'package:flutter/material.dart';
import 'package:todo_app_list/widget/calendar.dart';
import 'package:todo_app_list/widget/create_list.dart';

class TopBarBuild extends StatelessWidget {
  const TopBarBuild({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15.0),
      // decoration: BoxDecoration(
      //   color: Colors.deepPurple,
      // ),
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
              CalendarBuild(),
              SizedBox(width: 10),
              CreateTodoList(),
            ],
          )
        ],
      ),
    );
  }
}
