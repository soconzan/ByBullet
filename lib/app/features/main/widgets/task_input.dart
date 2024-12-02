import 'package:bybullet/app/features/main/controllers/nav_bar_controller.dart';
import 'package:bybullet/app/features/main/controllers/task_input_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';

class TaskInputWidget extends StatelessWidget {
  final NavBarController navBarController = Get.find<NavBarController>();
  final TaskInputController taskInputController =
      Get.find<TaskInputController>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    textController.addListener(() {
      taskInputController.isTextEmpty.value =
          textController.text.trim().isEmpty;
    });

    return GestureDetector(
      // close gesture
      onTap: () {
        taskInputController.isDialogVisible.value = false;
        navBarController.isTaskInputVisible.value = false;
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              // text input gesture
              onTap: () {},
              child: Container(
                // text input background
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // text
                    TextField(
                      controller: textController,
                      focusNode: taskInputController.focusNode,
                      decoration: InputDecoration(
                        hintText: "Enter task",
                        hintStyle: TextStyle(
                          color: AppColors.mediumGray,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        taskInputController.saveTask(textController);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // options & enter btn
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // options
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // bullets
                              _buildBulletSelector(),
                              SizedBox(
                                width: 10,
                              ),

                              // date
                              _buildDateSelector(),
                            ],
                          ),
                        ),

                        // enter
                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              taskInputController.saveTask(textController);
                            },
                            child: SvgPicture.asset(
                              'lib/assets/icons/enter_icon.svg',
                              color: taskInputController.isTextEmpty.value
                                  ? AppColors.mediumGray
                                  : AppColors.black,
                              width: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBulletSelector() {
    return Container(
      height: 45,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBulletItem("task", "lib/assets/icons/task_bullet.svg"),
          _buildBulletItem("priority", "lib/assets/icons/priority_bullet.svg"),
          _buildBulletItem("memo", "lib/assets/icons/memo_bullet.svg"),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String bullet, String iconPath) {
    return Obx(() => GestureDetector(
          onTap: () {
            taskInputController.selectedBullet(bullet);
          },
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: taskInputController.selectedBullet.value == bullet
                  ? AppColors.black
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                color: taskInputController.selectedBullet.value == bullet
                    ? AppColors.white
                    : AppColors.black,
                width: 12,
              ),
            ),
          ),
        ));
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: () => {taskInputController.isDialogVisible.value = true},
      child: Container(
        height: 45,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(45),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'lib/assets/icons/calendar_icon.svg',
              color: AppColors.black,
              width: 15,
            ),
            SizedBox(
              width: 8,
            ),
            Obx(() => Text(
                  taskInputController.formattedDate,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
