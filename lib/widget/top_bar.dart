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
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.sunny),
          Row(
            children: [
              CalendarBuild(),
              SizedBox(width: 10),
              CircleAvatar(
                foregroundColor: Colors.red,
                backgroundColor: Colors.red,
              )
            ],
          )
        ],
      ),
    );
  }
}
