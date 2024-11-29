import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TaskInputController extends GetxController {

  var isTextEmpty = true.obs;
  final FocusNode focusNode = FocusNode();

  void addTask(String text, TextEditingController textController) {
    if (text.trim().isNotEmpty) {
      print("Task added: ${textController.text}");
      textController.clear();
      isTextEmpty.value = true;
      focusNode.requestFocus();
    } else {
      print("Task button clicked, but null");
    }
  }
}