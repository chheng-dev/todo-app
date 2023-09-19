import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_list/models/task.dart';
import 'package:todo_app_list/remote_datasource/firestore_hleper.dart';

class TaskCardListToDobuild extends StatefulWidget {
  const TaskCardListToDobuild({
    super.key,
  });

  @override
  State<TaskCardListToDobuild> createState() => _TaskCardListToDobuildState();
}

class _TaskCardListToDobuildState extends State<TaskCardListToDobuild> {
  final leftEditButton = Container(
    margin: EdgeInsets.only(bottom: 10.0),
    color: Color(0xFF2e3253).withOpacity(0.5),
    child: Center(
      child: Text(
        "កែប្រែ",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 22,
        ),
      ),
    ),
  );

  final rightEditButton = Container(
    margin: EdgeInsets.only(bottom: 10.0),
    color: Colors.red,
    child: Center(
      child: InkWell(
        onTap: () async {
          // await FirestoreHelper.delete(TaskID)
        },
        child: Text(
          "លុបចោល",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
    ),
  );

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
              final TaskID = task.id;
              return Dismissible(
                background: leftEditButton,
                secondaryBackground: rightEditButton,
                onDismissed: (DismissDirection direction) async {
                  print(TaskID);
                  FirestoreHelper.delete(TaskID); // Call the delete function
                  print('Deleted $direction for item $index');
                },
                confirmDismiss: (DismissDirection direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return false;
                  } else {
                    return Future.delayed(Duration(seconds: 1),
                        () => direction == DismissDirection.endToStart);
                  }
                },
                key: ObjectKey(index),
                child: Card(
                  elevation: 2,
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Colors.green,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          task.title.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        InkWell(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.note.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      task.dateTime.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      task.toLocation.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  NumberFormat.simpleCurrency(name: 'USD')
                                      .format(task.amount),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delivery_dining,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4.0),
                                  Text(
                                    task.deliveryType.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.monetization_on_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4.0),
                                  Text(
                                    task.status.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
