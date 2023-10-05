import 'dart:ffi';
import 'dart:io';

// import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_list/Screen/HomePage.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:todo_app_list/models/task.dart';
import 'package:todo_app_list/remote_datasource/firestore_hleper.dart';
import 'package:todo_app_list/src/config/color_constants.dart';

class CardListReport extends StatefulWidget {
  const CardListReport({Key? key}) : super(key: key);

  @override
  State<CardListReport> createState() => _CardListReportState();
}

class _CardListReportState extends State<CardListReport> {
  String _selectedDate = DateFormat.yMd().format(DateTime.now());
  PageController controller = PageController(initialPage: 0);
  Stream<List<TaskModel>> _filterTaskStream = Stream.value([]);

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.refreshTaskList();
  }

  void refreshTaskList() {
    _filterTaskStream = FirestoreHelper().filterByDate(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskModel>>(
      stream: _filterTaskStream,
      builder: (context, AsyncSnapshot<List<TaskModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(
            child: Text("Some errors ocrrued"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            children: [
              SizedBox(height: 32),
              Container(
                child: Image.asset(
                  'assets/images/trash.png',
                  color: Colors.red,
                  width: 80,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "មិនមាន !!",
                style: TextStyle(
                  fontFamily: 'KantumruyPro',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.red,
                ),
              )
            ],
          );
        }
        if (snapshot.hasData) {
          List<TaskModel> tasks = snapshot.data!;
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ColorConstants.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(54),
                  ),
                ),
                padding: EdgeInsets.all(16),
                height: 180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "រាយការណ៍ប្រចាំថ្ងៃ",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'KantumruyPro',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          "Thu, 5 Oct 2023",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'KantumruyPro',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                _selectDateWidget(context);
                              },
                              child: Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 14),
                            InkWell(
                              onTap: () {
                                _generateAndSaveCsv(context);
                              },
                              child: Icon(
                                Icons.print_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              // SizedBox(height: 22),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(54),
                    topRight: Radius.circular(54),
                  ),
                ),
                margin: EdgeInsets.symmetric(vertical: 90),
                padding: EdgeInsets.only(bottom: 12),
                height: 680,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  child: ListView.builder(
                    itemCount: tasks.length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Container(
                        height: 80,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tasks[index].title,
                                    style: TextStyle(
                                      fontFamily: 'KantumruyPro',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('E, MMM d y').format(
                                      DateFormat.yMd()
                                          .parse(tasks[index].dateTime),
                                    ),
                                    style: TextStyle(
                                        fontFamily: 'KantumruyPro',
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _generateAndSaveCsv(context);
                                    },
                                    child: Icon(
                                      Icons.print,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '\$ ${tasks[index].amount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontFamily: 'KantumruyPro',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<void> _selectDateWidget(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      _selectedDate = DateFormat.yMd().format(selectedDate);
    }
  }

  Future<void> _generateAndSaveCsv(BuildContext context) async {
    // List<TaskModel> taskList = [
    //   TaskModel(
    //       id: "",
    //       title: 'Task 1',
    //       dateTime: "22222",
    //       amount: 2,
    //       status: 'pending',
    //       paymentMethod: 'ABC',
    //       deliveryType: 'VET',
    //       toLocation: 'PP',
    //       isCompleted: true,
    //       createdAt: DateTime.now(),
    //       updatedAt: DateTime.now()),
    // ];

    // Excel excel = Excel.createExcel();

    // // Create a worksheet
    // Sheet sheetObject = excel['Sheet1'];

    // // Add headers
    // sheetObject.appendRow(['Title', 'Description', 'Date']);

    // // Add data
    // for (var task in taskList) {
    //   sheetObject
    //       .appendRow([task.title, task.dateTime, task.dateTime.toString()]);
    // }

    // // Get the temporary directory
    // Directory tempDir = await getTemporaryDirectory();

    // // Generate a unique filename
    // String uniqueFileName =
    //     DateTime.now().millisecondsSinceEpoch.toString() + '.xlsx';

    // // Build the full path for the Excel file
    // String excelPath = '${tempDir.path}/$uniqueFileName';

    // final bytes = await excel.encode();
    // if (bytes != null) {
    //   await File(excelPath).writeAsBytes(bytes);
    //   print('Excel file saved at: $excelPath');

    //   // Add a delay to allow the file system to recognize the new file
    //   await Future.delayed(Duration(seconds: 2));

    //   // Open the Excel file
    //   OpenFile.open(excelPath);
    // } else {
    //   print('Failed to encode Excel file.');
    // }
  }
}
