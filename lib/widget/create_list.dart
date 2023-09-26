import 'package:alert_dialog/alert_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_list/models/task.dart';
import 'package:todo_app_list/remote_datasource/firestore_hleper.dart';
import 'package:todo_app_list/src/config/color_constants.dart';
import 'package:todo_app_list/widget/sd/alert_dialog.dart';
import 'package:todo_app_list/widget/text_field.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CreateTodoList());
}

class CreateTodoList extends StatefulWidget {
  const CreateTodoList({super.key});

  @override
  State<CreateTodoList> createState() => _CreateTodoListState();
}

class _CreateTodoListState extends State<CreateTodoList> {
  final FirestoreHelper taskCrudHelper = FirestoreHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: InkWell(
              onTap: () => ShowModalBottom(context),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future ShowModalBottom(context) {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _noteController = TextEditingController();
    TextEditingController _datetimeController = TextEditingController();
    TextEditingController _toLocationController = TextEditingController();
    TextEditingController _statusController = TextEditingController();
    TextEditingController _paymentMethodController = TextEditingController();
    TextEditingController _deliveryController = TextEditingController();
    String _statusOption = "ជោគជ័យ";
    String _paymentMethod = "សាច់ប្រាក់";
    String _deliveryType = "Grab";

    final TextEditingController _amountController = TextEditingController();

    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 12),
              height: MediaQuery.sizeOf(context).height * 0.8,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 22, horizontal: 18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Create New Task",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
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
                        )
                      ],
                    ),
                  ),
                  TextFielddBuild(
                    txtLable: "ឈ្មោះ",
                    readOnly: false,
                    hitText: "បញ្ចូលឈ្មោះ",
                    controller: _titleController,
                    suffixIcon: Icon(Icons.abc),
                  ),
                  SizedBox(height: 8.0),
                  //delivery Type
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "អ្នកដឹក",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey.shade200,
                        ),
                        dropdownColor: Colors.white,
                        value: _deliveryType,
                        items: ["CE Express", "Virakbuntham", "Grab", "J&T"]
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _deliveryType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  TextFielddBuild(
                    txtLable: "ទីតាំង",
                    readOnly: false,
                    hitText: "បញ្ចូលប្រភេទទីតាំង",
                    controller: _toLocationController,
                    suffixIcon: Icon(Icons.description),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFielddBuild(
                          txtLable: "តម្លៃ",
                          readOnly: false,
                          hitText: "បញ្ចូលតម្លៃ",
                          controller: _amountController,
                          suffixIcon: Icon(Icons.description),
                        ),
                      ),
                      SizedBox(width: 6.0),

                      // status
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ស្ថានភាព",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey.shade200,
                              ),
                              dropdownColor: Colors.white,
                              value: _statusOption,
                              items: ["ជោគជ័យ", "កំពុងដំណើរការ", "បោះបង់"]
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _statusOption = value!;
                                });
                              },
                              // decoration: InputDecoration(labelText: 'Gender'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8.0),

                  //payment
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "បង់តាមរយ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey.shade200,
                              ),
                              dropdownColor: Colors.white,
                              value: _paymentMethod,
                              items: [
                                "សាច់ប្រាក់",
                                "ABA Bank",
                                "ACLEDA",
                                "KHQR",
                                "Wing"
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _paymentMethod = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "នៅថ្ថៃ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _datetimeController,
                                      decoration: InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintText: "នៅថ្ថៃ",
                                      ),
                                      readOnly: true,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      DateTime? selectedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2100),
                                      );
                                      if (selectedDate != null) {
                                        _datetimeController.text =
                                            DateFormat.yMd()
                                                .format(selectedDate);
                                      }
                                    },
                                    child: Icon(Icons.calendar_month),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: ColorConstants.primary,
                              backgroundColor: Colors.white,
                              elevation: 0,
                              side: BorderSide(
                                color: ColorConstants.primary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text("បោះបង់"),
                            onPressed: () {
                              _titleController.clear();
                              _noteController.clear();
                              _datetimeController.clear();
                              _statusController.clear();
                              // amoutController.clear();
                              _paymentMethodController.clear();
                              _deliveryController.clear();
                            },
                          ),
                        ),
                        SizedBox(width: 6.0),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: ColorConstants.primary,
                              elevation: 0,
                              side: BorderSide(
                                color: ColorConstants.primary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("បន្ថែម"),
                            onPressed: () async {
                              double amount =
                                  double.tryParse(_amountController.text) ??
                                      0.0; // Parse double or default to 0.0

                              if (_titleController.text != "" ||
                                  _statusController.text != "" ||
                                  _toLocationController.text != "" ||
                                  _datetimeController.text != "") {
                                bool isCompleted = _statusOption == "ជោគជ័យ";

                                TaskModel newTask = TaskModel(
                                  id: '', // Firestore will generate an ID
                                  title: _titleController.text,
                                  dateTime: _datetimeController.text,
                                  amount: amount,
                                  status: _statusOption,
                                  isCompleted: isCompleted,
                                  paymentMethod: _paymentMethod,
                                  deliveryType: _deliveryType,
                                  toLocation: _toLocationController.text,
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                );
                                taskCrudHelper.addTask(newTask);
                                _titleController.clear();
                                _datetimeController.clear();
                                _statusController.clear();
                                amount = amount;
                                _deliveryController.clear();
                                Navigator.pop(context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomAlertDialog(
                                      title: "ព័ត៌មាន",
                                      content: "សូមជួយបំពេញចន្លោះទទេជាមុន។",
                                      onConfirm: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
