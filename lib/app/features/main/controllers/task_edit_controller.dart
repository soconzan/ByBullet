import 'package:bybullet/app/services/firestore_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskEditController extends GetxController {
  var isTaskEditVisible = false.obs;
  var isDialogVisible = false.obs;

  var selectedTaskId = "".obs;
  var selectedTaskText = "".obs;
  var selectedTaskDate = DateTime.now().obs;
  var selectedTaskTime = Rx<TimeOfDay?>(null);

  void setTaskForEditing(
      String id, String text, DateTime date, TimeOfDay? time) {
    selectedTaskId.value = id;
    selectedTaskText.value = text;
    selectedTaskDate.value = date;
    if (time != null) {
      selectedTaskTime.value = time;
    }
  }

  // void setTaskForEditing({
  //   required String id,
  //   required String text,
  //   required DateTime date,
  //   TimeOfDay? time,
  // }) {
  //   selectedTaskId.value = id;
  //   selectedTaskText.value = text;
  //   selectedTaskDate.value = date;
  //   if (time != null) {
  //     selectedTaskTime.value = time;
  //   }
  // }

  Future<void> saveTaskEdits() async {
    try {
      final updates = {
        "text": selectedTaskText.value,
        "date": DateFormat('yyyy-MM-dd').format(selectedTaskDate.value),
        "time": selectedTaskTime.value != null
            ? "${selectedTaskTime.value.toString().padLeft(2, '0')}:${selectedTaskTime.value.toString().padLeft(2, '0')}"
            : null,
      };
      await FirestoreService.updateTask(selectedTaskId.value, updates);
      print("Task updated successfully");
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  Future<void> deleteTask() async {
    try {
      await FirestoreService.deleteTask(selectedTaskId.value);
      print("Task deleted successfully");
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

}
