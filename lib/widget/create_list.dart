// import 'package:alert/alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_list/models/task.dart';
import 'package:todo_app_list/remote_datasource/firestore_hleper.dart';
import 'package:todo_app_list/src/config/color_constants.dart';
import 'package:todo_app_list/widget/calendar.dart';
import 'package:todo_app_list/widget/card_list.dart';
import 'package:todo_app_list/widget/dropdown.dart';
import 'package:todo_app_list/widget/text_field.dart';
import 'package:todo_app_list/widget/top_bar.dart';

// void main() {
//   runApp(const CreateTodoList());
// }

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
  // TextEditingController _taskTitle = TextEditingController();
  // TextEditingController _note = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryDark,
                  foregroundColor: Colors.white),
              onPressed: () => ShowModalBottom(context),
              child: Text("បង្កើតថ្មី"),
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
    TextEditingController _amoutController = TextEditingController();
    TextEditingController _statusController = TextEditingController();
    TextEditingController _paymentMethodController = TextEditingController();
    TextEditingController _deliveryController = TextEditingController();
    String _selectedOption = "ជោគជ័យ";
    String _paymentMethod = "សាច់ប្រាក់";
    String _deliveryType = "Grab";

    return showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (context) {
        return SafeArea(
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
                  txtLable: "ប្រភេទ",
                  readOnly: false,
                  hitText: "បញ្ចូលប្រភេទ",
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
                      items: [
                        "CE Express",
                        "Virakbuntham",
                        "Lasada",
                        "Grab",
                        "Loda"
                      ].map((String value) {
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
                        controller: _amoutController,
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
                            value: _selectedOption,
                            items: ["ជោគជ័យ", "កំពុងដំណើរការ", "បោះបង់"]
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedOption = value!;
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
                            items: ["សាច់ប្រាក់", "ABA Bank", "ACLEDA", "KHQR"]
                                .map((String value) {
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
                      // child: InkWell(
                      //   onTap: () async {
                      //     DateTime? selectedDate = await showDatePicker(
                      //       context: context,
                      //       initialDate: DateTime.now(),
                      //       firstDate: DateTime(1950),
                      //       lastDate: DateTime(2100),
                      //     );
                      //     if (selectedDate != null) {
                      //       _datetimeController.text =
                      //           DateFormat.yMd().format(selectedDate);
                      //     }
                      //   },
                      //   child: TextFielddBuild(
                      //     controller: _datetimeController,
                      //     txtLable: "នៅថ្ថៃ",
                      //     readOnly: true,
                      //     hitText: "នៅថ្ថៃ",
                      //     suffixIcon: Icon(Icons.calendar_month),
                      //   ),
                      // ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          DateFormat.yMd().format(selectedDate);
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
                            foregroundColor: ColorConstants.primaryDark,
                            backgroundColor: Colors.white,
                            elevation: 0,
                            side: BorderSide(
                              color: Colors.blue.shade800,
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
                            _amoutController.clear();
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
                            backgroundColor: ColorConstants.primaryDark,
                            elevation: 0,
                            side: BorderSide(
                              color: Colors.blue.shade800,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("បន្ថែម"),
                          onPressed: () {
                            if (_titleController.text != "" ||
                                _statusController.text != "" ||
                                _amoutController.text != "" ||
                                _toLocationController.text != "" ||
                                _datetimeController.text != "") {
                              FirestoreHelper.create(
                                TaskModel(
                                  id: UniqueKey().toString(),
                                  title: _titleController.text,
                                  dateTime: _datetimeController.text,
                                  status: _selectedOption,
                                  amount: int.parse(_amoutController.text),
                                  paymentMethod: _paymentMethod,
                                  deliveryType: _deliveryType,
                                  toLocation: _toLocationController.text,
                                ),
                              );
                              _titleController.clear();
                              _datetimeController.clear();
                              _statusController.clear();
                              _amoutController.clear();
                              _deliveryController.clear();
                              Navigator.pop(context);
                            } else {
                              // ShowAlert
                              // Alert(message: "Hello world").show();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //         child: ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.orange.shade400,
                //           ),
                //           onPressed: () {
                //             _taskTitle.clear();
                //           },
                //           child: Text(
                //             "Clear",
                //             style: TextStyle(
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.w800),
                //           ),
                //         ),
                //       ),
                //       SizedBox(width: 8.0),
                //       Expanded(
                //         child: ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: Colors.blue.shade400,
                //           ),
                //           onPressed: () {
                //             if (_titleController.text != "" &&
                //                 _noteController.text != "" &&
                //                 _datetimeController.text != "" &&
                //                 _timeController.text != "") {
                //               FirestoreHelper.create(
                //                 TaskModel(
                //                     id: UniqueKey().toString(),
                //                     title: _titleController.text,
                //                     note: _noteController.text,
                //                     date: _datetimeController.text,
                //                     time: _timeController.text),
                //               );
                //               _titleController.clear();
                //               _noteController.clear();
                //               _datetimeController.clear();
                //               _timeController.clear();
                //               Navigator.pop(context);
                //             } else {
                //               print("please fill the infomation !");
                //             }
                //           },
                //           child: Text(
                //             "Create",
                //             style: TextStyle(
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.w800),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
