import 'package:bybullet/app/features/main/controllers/nav_bar_controller.dart';
import 'package:bybullet/app/features/main/controllers/task_input_controller.dart';
import 'package:bybullet/app/features/main/widgets/date_selector_dialog.dart';
import 'package:bybullet/app/features/main/widgets/task_input.dart';
import 'package:flutter/material.dart';
import '../../app/features/main/widgets/nav_bar.dart';
import '../../app/features/main/widgets/daily_app_bar.dart';
import 'package:get/get.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final NavBarController navBarController = Get.find<NavBarController>();
  final TaskInputController taskInputController =
      Get.find<TaskInputController>();

  MainLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DailyAppBar(),
      body: Obx(
        () => Stack(
          children: [
            child,
            if (navBarController.isTaskInputVisible.value) TaskInputWidget(),
            if (taskInputController.isDialogVisible.value)
              DateSelectorDialogWidget(),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
