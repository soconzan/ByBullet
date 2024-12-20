import 'package:bybullet/app/features/main/controllers/daily_controller.dart';
import 'package:bybullet/app/features/main/controllers/nav_bar_controller.dart';
import 'package:bybullet/app/features/main/controllers/task_input_controller.dart';
import 'package:get/get.dart';

import '../controllers/task_edit_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavBarController>(() => NavBarController());
    Get.lazyPut<TaskInputController>(() => TaskInputController());
    Get.lazyPut<TaskEditController>(() => TaskEditController());
    Get.lazyPut<DailyController>(() => DailyController());
  }
}
