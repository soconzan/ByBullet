import 'package:bybullet/app/features/main/controllers/daily_controller.dart';
import 'package:bybullet/app/features/main/controllers/nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../controllers/task_edit_controller.dart';

class TaskEditWidget extends StatelessWidget {
  final TaskEditController taskEditController = Get.find<TaskEditController>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    textController.text = taskEditController.selectedTaskText.value;

    return GestureDetector(
      // close gesture
      onTap: () {
        taskEditController.isTaskEditVisible.value = false;
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
                      decoration: InputDecoration(
                        hintText: "Edit task",
                        hintStyle: TextStyle(color: AppColors.mediumGray),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        taskEditController.selectedTaskText.value = value;
                      },
                      onSubmitted: (value) {
                        taskEditController.saveTaskEdits();
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
                              // date
                              _buildDateSelector(),
                            ],
                          ),
                        ),

                        // delete & enter
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // delete
                            GestureDetector(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'lib/assets/icons/bin_icon.svg',
                                color: AppColors.mediumGray,
                                width: 20,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),

                            // enter
                            GestureDetector(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'lib/assets/icons/check_icon.svg',
                                color: AppColors.black,
                                width: 20,
                              ),
                            ),
                          ],
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

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: () => {taskEditController.isDialogVisible.value = true},
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
            // Obx(() => Text(
            //       taskEditController.formattedDate,
            //       style: TextStyle(
            //         fontSize: 16,
            //       ),
            //     )),
          ],
        ),
      ),
    );
  }
}
