import 'package:flutter/material.dart';
import 'package:todo_app_list/widget/create_list.dart';

class TopBarBuild extends StatefulWidget {
  const TopBarBuild({Key? key}) : super(key: key);

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
              CreateTodoList(),
            ],
          )
        ],
      ),
    );
  }
}
