import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? id;
  String? title;
  String? note;
  String? dateTime;
  String? toLocation;
  int? amount;
  String? status;
  String? paymentMethod;
  String? deliveryType;

  TaskModel(
      {this.id,
      this.title,
      this.toLocation,
      this.dateTime,
      this.amount,
      this.status,
      this.paymentMethod,
      this.deliveryType});

  factory TaskModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return TaskModel(
      id: snapshot['id'],
      title: snapshot['title'],
      dateTime: snapshot['dateTime'],
      amount: snapshot['amount'],
      status: snapshot['status'],
      paymentMethod: snapshot['paymentMethod'],
      deliveryType: snapshot['deliveryType'],
      toLocation: snapshot['toLocation'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "dateTime": dateTime,
        "amount": amount,
        "status": status,
        "paymentMethod": paymentMethod,
        "deliveryType": deliveryType,
        "toLocation": toLocation
      };
}
