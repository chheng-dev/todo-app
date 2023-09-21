import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_list/models/task.dart';
import 'package:todo_app_list/remote_datasource/firestore_hleper.dart';
import 'package:todo_app_list/src/config/color_constants.dart';
import 'package:todo_app_list/widget/create_list.dart';
import 'package:todo_app_list/widget/edit_tak.dart';

class CardWidgetBuild extends StatefulWidget {
  final Stream<List<TaskModel>> tasksStream;

  const CardWidgetBuild({
    Key? key,
    required this.tasksStream,
  }) : super(key: key);

  @override
  State<CardWidgetBuild> createState() => _CardWidgetBuildState();
}

class _CardWidgetBuildState extends State<CardWidgetBuild> {
  DateFormat timeFormat = DateFormat('hh:mm a');
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  final leftEditButton = Container(
    color: Colors.grey.shade200,
    padding: EdgeInsets.only(left: 8),
    alignment: Alignment.centerLeft,
    child: Text(
      "កែប្រែ",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 22,
      ),
    ),
  );

  final rightEditButton = Container(
    margin: EdgeInsets.only(bottom: 10.0),
    color: Colors.orange.shade400,
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: 8),
    child: Text(
      "លុបចោល",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 22,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final FirestoreHelper taskCrudHelper = FirestoreHelper();

    return StreamBuilder<List<TaskModel>>(
      stream: widget.tasksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Some errors ocrrued"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            alignment: Alignment.topCenter,
            child: Image.asset('assets/images/empty.png'),
          );
        }

        if (snapshot.hasData) {
          List<TaskModel> task = snapshot.data!;
          return ListView.builder(
            itemCount: task.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Dismissible(
                background: leftEditButton,
                secondaryBackground: rightEditButton,
                onDismissed: (DismissDirection direction) async {
                  taskCrudHelper.deleteTask(task[index].id);
                },
                confirmDismiss: (DismissDirection direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    () => CreateTodoList();
                  } else {
                    return Future.delayed(Duration(seconds: 1),
                        () => direction == DismissDirection.endToStart);
                  }
                },
                key: ObjectKey(task[index]),
                child: Column(
                  children: [
                    InkWell(
                      onDoubleTap: () =>
                          _toggleCompletion(context, task[index]),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        margin: EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 120,
                              child: Column(
                                children: [
                                  Text(
                                    timeFormat.format(
                                      dateFormat.parse(task[index].dateTime),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task[index].title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.delivery_dining_rounded,
                                          size: 17,
                                          color: Colors.grey.shade800,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          task[index].toLocation,
                                          style: TextStyle(
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Container(
                            //   padding: EdgeInsets.only(right: 5),
                            //   child: Checkbox(
                            //     onChanged: (value) {},
                            //     value: _isChecked,
                            //   ),
                            // ),
                            Container(
                              padding: EdgeInsets.only(right: 5),
                              width: 20,
                              child: CircleAvatar(
                                  backgroundColor:
                                      _getBackgroundColor(task[index].status)),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 5),
                              child: EditTodoList(
                                task: task[index],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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

  Color _getBackgroundColor(String status) {
    switch (status) {
      case 'ជោគជ័យ':
        return Colors.green;
      case 'កំពុងដំណើរការ':
        return Colors.orange.shade400;
      case 'បោះបង់':
        return Colors.red;
      default:
        return Colors.white; // Default color, adjust as needed
    }
  }

  void _toggleCompletion(BuildContext context, TaskModel taskModel) async {
    print("hello");
    String? updateStatus = await showDialog<String>(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          child: AlertDialog(
            title: Text('Update Task Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Current Status: ${_getStatusDisplay(taskModel.isCompleted, taskModel.status)}',
                ),
                SizedBox(height: 16.0),
                Text('Select New Status:'),
                DropdownButton(
                    items: ["ជោគជ័យ", "កំពុងដំណើរការ", "បោះបង់"]
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      Navigator.pop(context, newValue);
                    })
              ],
            ),
          ),
        );
      },
    );

    if (updateStatus != null) {
      bool _isCompleted = updateStatus == 'ជោគជ័យ';

      TaskModel updatTaskModel = TaskModel(
        id: taskModel.id,
        title: taskModel.title,
        dateTime: taskModel.dateTime,
        amount: taskModel.amount,
        status: updateStatus,
        isCompleted: _isCompleted,
        paymentMethod: taskModel.paymentMethod,
        deliveryType: taskModel.deliveryType,
        toLocation: taskModel.toLocation,
      );
      FirestoreHelper().updateTask(updatTaskModel);
    }
  }
  // items: ["ជោគជ័យ", "កំពុងដំណើរការ", "បោះបង់"]

  String _getStatusDisplay(bool? isCompleted, String? status) {
    if (isCompleted == false && status == "បោះបង់") {
      return 'បោះបង់';
    } else if (isCompleted == true) {
      return 'ជោគជ័យ';
    } else {
      return 'កំពុងដំណើរការ';
    }
    // return isCompleted ? 'ជោគជ័យ' : 'កំពុងដំណើរការ';
  }

  bool? _getStatusValue(String? status) {
    if (status == 'ជោគជ័យ') {
      return true;
    } else if (status == 'បោះបង់') {
      return null; // Use null to indicate 'Cancelled'
    } else {
      return false;
    }
  }
}
