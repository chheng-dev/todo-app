import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  // final DateTime dateTime;
  String dateTime;
  final double amount;
  final String status;
  final String paymentMethod;
  final String deliveryType;
  final String toLocation;
  final bool? isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.deliveryType,
    required this.toLocation,
    this.isCompleted,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return TaskModel(
      id: doc.id,
      title: data['title'],
      dateTime: data['dateTime'],
      amount: data['amount'],
      status: data['status'],
      paymentMethod: data['paymentMethod'],
      deliveryType: data['deliveryType'],
      toLocation: data['toLocation'],
      isCompleted: data['isCompleted'],
    );
  }
}
