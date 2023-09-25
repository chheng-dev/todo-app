import 'package:bottom_bar/bottom_bar.dart';
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

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _searchQuery = '';
  DateTime filterDate = DateTime.now();
  PageController controller = PageController(initialPage: 0);
  var selectedPage = 0;

  void _updateSelectedDate(DateTime date) {
    print(date);
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Stream<List<TaskModel>> _filterTaskStream = FirestoreHelper().getTaskList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PageView(
        controller: controller,
        children: [
          SafeArea(
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
                          height: 180,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15.0),
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
                              TopBarBuild(
                                onDateSelected: _updateSelectedDate,
                              ),
                              SizedBox(height: 20),
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
                                          _filterTaskStream =
                                              FirestoreHelper().searchTasks(
                                            _searchQuery,
                                          );
                                        });
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12),
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
        ],
      ),
      bottomNavigationBar: BottomBar(
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        selectedIndex: selectedPage,
        onTap: (int index) {
          controller.jumpToPage(index);
          setState(() => selectedPage = index);
        },
        items: <BottomBarItem>[
          BottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: ColorConstants.primary,
            activeTitleColor: ColorConstants.primary,
          ),
          BottomBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
            activeColor: ColorConstants.primary,
            activeTitleColor: ColorConstants.primary,
          ),
          BottomBarItem(
            icon: Icon(Icons.person),
            title: Text('Account'),
            activeColor: ColorConstants.primary,
            activeTitleColor: ColorConstants.primary,
          ),
          BottomBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            activeColor: ColorConstants.primary,
            activeTitleColor: ColorConstants.primary,
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: filterDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != filterDate) {
      setState(() {
        filterDate = picked;
      });
    }
  }
}
