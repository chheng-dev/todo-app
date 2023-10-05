import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_list/models/task.dart';
import 'package:todo_app_list/remote_datasource/firestore_hleper.dart';
import 'package:todo_app_list/src/config/color_constants.dart';
import 'package:todo_app_list/widget/card.dart';
import 'package:todo_app_list/widget/datepicker_widget.dart';
import 'package:todo_app_list/widget/search_widget_build.dart';
import 'package:todo_app_list/widget/top_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _searchQuery = '';
  String _selectedDate = "";
  PageController controller = PageController(initialPage: 0);
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
    });
    refreshTaskList();
    // "Wed 27.09.2023"
  }

  void refreshTaskList() {
    _filterTaskStream =
        FirestoreHelper().getTaskList(_searchQuery, _selectedDate);
  }

  @override
  void initState() {
    super.initState();
    this.refreshTaskList();

    setState(() {
      if (formattedDate.isEmpty) {
        DateTime initailizeDatetime = DateTime.now();
        String selectedDate = DateFormat('E, MMM d').format(initailizeDatetime);
        formattedDate = selectedDate;
      }
    });
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 180,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 15.0,
                          ),
                          decoration: BoxDecoration(
                            color: ColorConstants.primary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(44),
                              // bottomRight: Radius.circular(38),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TopBarBuild(
                                      formattedDate: formattedDate,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    child:
                                        DatePickerWidget(_updateSelectedDate),
                                  ),
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(54),
                              topRight: Radius.circular(54),
                            ),
                          ),
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  height: 500,
                                  child: CardWidgetBuild(
                                    tasksStream: _filterTaskStream,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}
