import 'package:bybullet/app/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskInputController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  var isTextEmpty = true.obs;
  var selectedBullet = "task".obs;
  var selectedDate = DateTime.now().obs;
  var isAllDay = true.obs;
  var isDialogVisible = true.obs;

  final FocusNode focusNode = FocusNode();

  Future<void> saveTask(TextEditingController textController) async {
    // if (text.trim().isNotEmpty) {
    //   print("Task added: ${textController.text}");
    //   textController.clear();
    //   isTextEmpty.value = true;
    //   focusNode.requestFocus();
    // } else {
    //   print("Task button clicked, but null");
    // }
    try{
      await _firestoreService.saveTask(textController.text, selectedBullet.value, selectedDate.value);
      print("Task saved successfully");
      textController.clear();
      isTextEmpty.value=true;
      focusNode.requestFocus();
    } catch (e) {
      print("Error saving task: $e");
    }
  }

  void selectBullet(String bullet) {
    selectedBullet.value = bullet;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void toggleAllDay(bool value) {
    isAllDay.value = value;
  }

  String get formattedDate {
    final today = DateTime.now();

    final dateFormat = DateFormat("M월 d일");
    final timeFormat = DateFormat("hh:mm a");

    String dateString = isSameDay(selectedDate.value, today)
        ? "today"
        : dateFormat.format(selectedDate.value);

    String timeString =
        isAllDay.value ? "" : ", " + timeFormat.format(selectedDate.value);

    return "$dateString$timeString";
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
