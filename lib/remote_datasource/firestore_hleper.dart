import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_list/models/task.dart';

class FirestoreHelper {
  static Future create(TaskModel taskModel) async {
    final taskCollection = FirebaseFirestore.instance.collection("task");
    final docsRef = taskCollection.doc();

    final newTask = new TaskModel(
      id: taskModel.id,
      title: taskModel.title,
      dateTime: taskModel.dateTime,
      toLocation: taskModel.toLocation,
      paymentMethod: taskModel.paymentMethod,
      deliveryType: taskModel.deliveryType,
      status: taskModel.status,
      amount: taskModel.amount,
    ).toJson();

    try {
      await docsRef.set(newTask);
    } catch (e) {
      print("some errros occrued $e");
    }
  }

  static Stream<List<TaskModel>> read() {
    final taskColection = FirebaseFirestore.instance.collection('task');
    return taskColection.snapshots().map(
          (event) => event.docs.map((e) => TaskModel.fromSnapshot(e)).toList(),
        );
  }

  static Future<void> delete(String? TaskID) async {
    final taskCollection = FirebaseFirestore.instance.collection("task");
    try {
      await taskCollection.doc(TaskID).delete();
      print('Task with ID $TaskID deleted successfully.');
    } catch (e) {
      print("some errros occrued $e");
    }
  }
}
