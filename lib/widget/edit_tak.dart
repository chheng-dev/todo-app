// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todo_app_list/models/task.dart';
import 'package:todo_app_list/remote_datasource/firestore_hleper.dart';
import 'package:todo_app_list/src/config/color_constants.dart';
import 'package:todo_app_list/widget/text_field.dart';

class EditTodoList extends StatefulWidget {
  const EditTodoList({
    Key? key,
    required this.task,
  }) : super(key: key);
  final TaskModel task;

  @override
  State<EditTodoList> createState() => _EditTodoListState();
}

class _EditTodoListState extends State<EditTodoList> {
  final FirestoreHelper taskCrudHelper = FirestoreHelper();
  late TextEditingController _titleController;
  late TextEditingController _toLocationController;
  late TextEditingController _amountController;
  late TextEditingController _selectedDateTime;

  String _selectedDeliveryType = 'Grab'; // Default delivery
  String _selectedStatus = 'កំពុងដំណើរការ';
  String _selectedPaymethdOpetion = 'សាច់ប្រាក់';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _toLocationController = TextEditingController(text: widget.task.toLocation);
    _amountController =
        TextEditingController(text: widget.task.amount.toString());
    _selectedDateTime = TextEditingController(text: widget.task.dateTime);

    //convert amount double to string

    // edit delivery type
    if (widget.task.deliveryType == 'Grab') {
      _selectedDeliveryType = "Grab";
    } else if (widget.task.deliveryType == 'Virakbuntham') {
      _selectedDeliveryType = "Virakbuntham";
    } else if (widget.task.deliveryType == "CE Express") {
      _selectedDeliveryType = "CE Express";
    } else {
      _selectedDeliveryType = "J&T";
    }

    //show status
    if (widget.task.status == 'កំពុងដំណើរការ') {
      _selectedStatus = 'កំពុងដំណើរការ';
    } else if (widget.task.status == 'ជោគជ័យ') {
      _selectedStatus = 'ជោគជ័យ';
    } else if (widget.task.status == 'បោះបង់') {
      _selectedStatus = 'បោះបង់';
    }

    //  items: ["សាច់ប្រាក់", "ABA Bank", "ACLEDA","Wing","KHQR"]
    // payment method
    if (widget.task.paymentMethod == 'សាច់ប្រាក់') {
      _selectedPaymethdOpetion = 'សាច់ប្រាក់';
    } else if (widget.task.status == 'ABA Bank') {
      _selectedPaymethdOpetion = 'ABA Bank';
    } else if (widget.task.status == 'ACLEDA') {
      _selectedPaymethdOpetion = 'ACLEDA';
    } else if (widget.task.status == 'Wing') {
      _selectedPaymethdOpetion = 'Wing';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: InkWell(
              onTap: () => ShowModalBottom(context),
              child: Icon(
                Icons.edit_note,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future ShowModalBottom(context) {
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
              height: MediaQuery.sizeOf(context).height * 0.8,
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 12),
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
                          "Edit Task",
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
                  // //delivery Type
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
                        value: _selectedDeliveryType,
                        items: ["CE Express", "Virakbuntham", "Grab", "J&T"]
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedDeliveryType = value!;
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
                          //  keyboardType: TextInputType.number,
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
                              value: _selectedStatus,
                              items: ["ជោគជ័យ", "កំពុងដំណើរការ", "បោះបង់"]
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedStatus = value!;
                                });
                              },
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
                              value: _selectedPaymethdOpetion,
                              items: [
                                "សាច់ប្រាក់",
                                "ABA Bank",
                                "ACLEDA",
                                "Wing",
                                "KHQR"
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedPaymethdOpetion = value!;
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
                                      controller: _selectedDateTime,
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
                                        _selectedDateTime.text =
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
                            child: Text("ត្រលប់"),
                            onPressed: () {
                              Navigator.pop(context);
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
                            child: const Text("Update"),
                            onPressed: () async {
                              double amount =
                                  double.tryParse(_amountController.text) ??
                                      0.0;
                              bool? isCompleted = _selectedStatus == "ជោគជ័យ";

                              // if (_titleController.text != "" ||
                              //     _statusController.text != "" ||
                              //     _toLocationController.text != "" ||
                              //     _selectedDateTime.text != "") {
                              TaskModel updateTask = TaskModel(
                                id: widget
                                    .task.id, // Firestore will generate an ID
                                title: _titleController.text,
                                dateTime: _selectedDateTime.text,
                                amount: amount,
                                status: _selectedStatus,
                                isCompleted: isCompleted,
                                paymentMethod: _selectedPaymethdOpetion,
                                deliveryType: _selectedDeliveryType,
                                toLocation: _toLocationController.text,
                              );
                              taskCrudHelper.updateTask(updateTask);
                              Navigator.pop(context);
                              // } else {
                              //   // ShowAlert
                              //   // Alert(message: "Hello world").show();
                              // }
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
