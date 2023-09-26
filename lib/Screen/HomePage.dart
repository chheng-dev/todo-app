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
import 'package:todo_app_list/widget/datepicker_widget.dart';
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
  String _selectedDate = "";
  PageController controller = PageController(initialPage: 0);
  var selectedPage = 0;
  String formattedDate = "";

  Stream<List<TaskModel>> _filterTaskStream = Stream.value([]);

  void updateSearchQuery(String query) {
    print(query);
    setState(() {
      _searchQuery = query;
    });
    refreshTaskList();
  }

  void _updateSelectedDate(String date) {
    setState(() {
      _selectedDate = date;

      formattedDate =
          DateFormat('E, MMM d').format(DateFormat.yMd().parse(date));
      print(formattedDate);
    });
    refreshTaskList();
  }

  void refreshTaskList() {
    _filterTaskStream =
        FirestoreHelper().getTaskList(_searchQuery, _selectedDate);
  }

  @override
  void initState() {
    super.initState();
    this.refreshTaskList();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                              Row(
                                children: [
                                  Expanded(child: TopBarBuild()),
                                  Container(
                                      child: DatePickerWidget(
                                          _updateSelectedDate)),
                                ],
                              ),
                              SizedBox(height: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SearchWidgetBuild(updateSearchQuery),
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
                                  formattedDate,
                                  style: TextStyle(
                                    fontSize: 22,
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
}
