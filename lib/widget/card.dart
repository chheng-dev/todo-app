import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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
      builder: (context, AsyncSnapshot<List<TaskModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/not-found.svg',
                  width: 200,
                ),
                SizedBox(height: 24),
                Text(
                  "Some Errors",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorConstants.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: InkWell(
                    child: Text("Home"),
                  ),
                ),
                // Lottie.asset('assets/icons/emtpy.json'),
              ],
            ),
            // child: Text("Some errors ocrrued"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/not-found.svg',
                  width: 200,
                ),
                SizedBox(height: 24),
                Text(
                  "មិនមានទិន្នន័យ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    fontFamily: "KantumruyPro",
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorConstants.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: InkWell(
                    child: Text("Home"),
                  ),
                ),
                // Lottie.asset('assets/icons/emtpy.json'),
              ],
            ),
          );
        }

        if (snapshot.hasData) {
          List<TaskModel> task = snapshot.data!;
          task.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return Container(
            decoration: BoxDecoration(),
            child: ListView.builder(
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
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                width: 1.5,
                                color: Colors.grey.shade400.withOpacity(0.5),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 120,
                                child: Column(
                                  children: [
                                    Text(
                                      '\$ ${task[index].amount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: _getBackgroundColor(
                                            task[index].status),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task[index].title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontFamily: "KantumruyPro",
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
                                              fontFamily: "KantumruyPro",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                width: 20,
                                child: CircleAvatar(
                                  backgroundColor:
                                      _getBackgroundColor(task[index].status),
                                ),
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
            ),
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
    String? updateStatus = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(54),
              topRight: Radius.circular(54),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          height: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Status: ${_getStatusDisplay(taskModel.isCompleted, taskModel.status)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'KantumruyPro',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Select New Status:',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'KantumruyPro',
                ),
              ),
              SizedBox(height: 4.0),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
                dropdownColor: Colors.grey.shade200,
                items:
                    ["ជោគជ័យ", "កំពុងដំណើរការ", "បោះបង់"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  Navigator.pop(context, newValue);
                },
              )
            ],
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
        createdAt: taskModel.createdAt,
        updatedAt: taskModel.updatedAt,
      );
      FirestoreHelper().updateTask(updatTaskModel);
    }
  }

  String _getStatusDisplay(bool? isCompleted, String? status) {
    if (isCompleted == false && status == "បោះបង់") {
      return 'បោះបង់';
    } else if (isCompleted == true) {
      return 'ជោគជ័យ';
    } else {
      return 'កំពុងដំណើរការ';
    }
  }

  bool? _getStatusValue(String? status) {
    if (status == 'ជោគជ័យ') {
      return true;
    } else if (status == 'បោះបង់') {
      return null;
    } else {
      return false;
    }
  }
}
