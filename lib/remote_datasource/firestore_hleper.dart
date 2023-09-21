import 'package:cloud_firestore/cloud_firestore.dart';
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
      'isCompleted': taskModel.isCompleted
    });
  }

  Stream<List<TaskModel>> searchTasks(String query) {
    return FirebaseFirestore.instance
        .collection("task")
        .where("title", isGreaterThanOrEqualTo: query)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  Stream<List<TaskModel>> getTaskList() {
    return taskCollectionRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }
}
