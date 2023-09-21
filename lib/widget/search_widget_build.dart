import 'package:flutter/material.dart';
import 'package:todo_app_list/models/task.dart';
import 'package:todo_app_list/remote_datasource/firestore_hleper.dart';
import 'package:todo_app_list/src/config/color_constants.dart';

class SearchWidgetBuild extends StatefulWidget {
  const SearchWidgetBuild({
    super.key,
  });

  @override
  State<SearchWidgetBuild> createState() => _SearchWidgetBuildState();
}

class _SearchWidgetBuildState extends State<SearchWidgetBuild> {
  final FirestoreHelper taskCrudHelper = FirestoreHelper();
  late Stream<List<TaskModel>> _taskStream;

  @override
  void initState() {
    super.initState();
    _taskStream = taskCrudHelper.getTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          child: TextField(
            onChanged: _onSearchTextChanged,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              labelText: "ស្វែងរក....",
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIcon: Icon(
                Icons.search,
                color: ColorConstants.primary,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  void _onSearchTextChanged(String query) {
    print("hello");
    print(query);
    setState(() {
      _taskStream = taskCrudHelper.searchTasks(query);
      print(_taskStream);
    });
  }
}
