import 'package:bybullet/app/features/main/controllers/daily_controller.dart';
import 'package:bybullet/app/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskInputController extends GetxController {
  final DailyController dailyController = Get.find<DailyController>();
  final FocusNode focusNode = FocusNode();

  var isTextEmpty = true.obs;
  var selectedBullet = "task".obs;
  var selectedDate = DateTime.now().obs;
  var selectedTime = Rx<TimeOfDay?>(null);
  var isAllDay = true.obs;
  var isDialogVisible = false.obs;

  @override
  void onInit() {
    super.onInit();

    ever(dailyController.currentDate, (date) {
      selectedDate.value = date as DateTime;
    });
  }


  // save Task
  Future<void> saveTask(TextEditingController textController) async {
    print("what happend");
    try {
      await FirestoreService.saveTask(textController.text, selectedBullet.value,
          selectedDate.value, selectedTime.value);
      print("Task saved successfully");
      textController.clear();
      isAllDay.value = true;
      isTextEmpty.value = true;
      focusNode.requestFocus();
      dailyController.fetchTasks();
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

  void selectTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  void toggleAllDay(bool value) {
    isAllDay.value = value;
    if (value)
      selectedTime.value = null;
    else
      selectedTime.value = TimeOfDay.now();
  }

  String get formattedDate {
    final today = DateTime.now();

    final dateFormat = DateFormat("M월 d일");

    String dateString = isSameDay(selectedDate.value, today)
        ? "today"
        : dateFormat.format(selectedDate.value);

    final timeString = selectedTime.value != null
        ? ', ${selectedTime.value!.hour.toString().padLeft(2, '0')}:${selectedTime.value!.minute.toString().padLeft(2, '0')}'
        : '';

    return "$dateString$timeString";
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
