import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_list/models/task.dart';
import 'package:todo_app_list/remote_datasource/firestore_hleper.dart';
import 'package:todo_app_list/src/config/color_constants.dart';
import 'package:todo_app_list/widget/calendar.dart';

class CardListToDobuild extends StatefulWidget {
  const CardListToDobuild({
    super.key,
  });

  @override
  State<CardListToDobuild> createState() => _CardListToDobuildState();
}

class _CardListToDobuildState extends State<CardListToDobuild> {
  // final TaskModel taskModel;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskModel>>(
      stream: FirestoreHelper.read(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Some errors ocrrued"),
          );
        }
        if (snapshot.hasData) {
          final taskList = snapshot.data;
          return ListView.builder(
            itemCount: taskList!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final task = taskList[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Card(
                  elevation: 2,
                  color: ColorConstants.primaryDark,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              task.title.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  task.dateTime.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                Icon(
                                  CupertinoIcons.calendar,
                                  color: Colors.white,
                                  size: 16,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              task.note.toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  task.dateTime.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                Icon(
                                  CupertinoIcons.calendar,
                                  color: Colors.white,
                                  size: 16,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
