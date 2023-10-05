import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_list/models/task.dart';

class FirestoreHelper {
  final CollectionReference taskCollectionRef =
      FirebaseFirestore.instance.collection("task");

  Future<void> addTask(TaskModel taskModel) async {
    await taskCollectionRef.add({
      'title': taskModel.title,
      'dateTime': taskModel.dateTime,
      'amount': taskModel.amount,
      'status': taskModel.status,
      'paymentMethod': taskModel.paymentMethod,
      'deliveryType': taskModel.deliveryType,
      'toLocation': taskModel.toLocation,
      'isCompleted': taskModel.isCompleted,
      'createdAt': taskModel.createdAt,
      'updatedAt': taskModel.updatedAt,
    });
  }

  Future<void> deleteTask(String taskID) async {
    await taskCollectionRef.doc(taskID).delete();
  }

  Future<void> updateTask(TaskModel taskModel) async {
    await taskCollectionRef.doc(taskModel.id).update({
      'title': taskModel.title,
      'dateTime': taskModel.dateTime,
      'amount': taskModel.amount,
      'status': taskModel.status,
      'paymentMethod': taskModel.paymentMethod,
      'deliveryType': taskModel.deliveryType,
      'toLocation': taskModel.toLocation,
      'isCompleted': taskModel.isCompleted,
      'updatedAt': taskModel.updatedAt,
    });
  }

  Stream<List<TaskModel>> searchTasks(String query) {
    return FirebaseFirestore.instance
        .collection("task")
        .snapshots()
        .map((snapshot) {
      print(snapshot.docs);
      return snapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .where(
              (task) => task.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Stream<List<TaskModel>> getTaskList(String searchQuery, String selectedDate) {
    Query query = FirebaseFirestore.instance.collection("task");

    if (searchQuery.isNotEmpty) {
      query = query.where("title", isGreaterThanOrEqualTo: searchQuery);
    }

    if (selectedDate.isNotEmpty) {
      query = query.where("dateTime", isEqualTo: selectedDate);
    } else {
      String parsedDate = DateFormat.yMd().format(DateTime.now());
      query = query.where("dateTime", isEqualTo: parsedDate);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  Stream<List<TaskModel>> filterByDate(String selectedDate) {
    Query query = FirebaseFirestore.instance.collection("task");

    query = query.where("dateTime", isEqualTo: selectedDate);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }
}
