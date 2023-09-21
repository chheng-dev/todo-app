import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app_list/models/task.dart';
import 'package:todo_app_list/remote_datasource/firestore_hleper.dart';
import 'package:todo_app_list/src/config/color_constants.dart';
import 'package:todo_app_list/widget/card.dart';
import 'package:todo_app_list/widget/create_list.dart';
import 'package:todo_app_list/widget/search_widget_build.dart';
import 'package:todo_app_list/widget/task_card_list.dart';
import 'package:todo_app_list/widget/top_bar.dart';

void main() {
  runApp(const Homepage());
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _searchQuery = '';
  Stream<List<TaskModel>> _filterTaskStream = FirestoreHelper().getTaskList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.grey.shade300.withOpacity(0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      // height: MediaQuery.of(context).size.height * 0.2,
                      height: 180,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(38),
                          bottomRight: Radius.circular(38),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TopBarBuild(),
                          SizedBox(height: 20),
                          // SearchWidgetBuild(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                color: Colors.white,
                                width: double.infinity,
                                child: TextField(
                                  onChanged: (query) {
                                    setState(() {
                                      _searchQuery = query;
                                      _filterTaskStream = FirestoreHelper()
                                          .searchTasks(_searchQuery);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 12),
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
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              "Today",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.primary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 500,
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: CardWidgetBuild(
                            tasksStream: _filterTaskStream,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
