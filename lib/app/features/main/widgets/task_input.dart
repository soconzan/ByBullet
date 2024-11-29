import 'package:bybullet/app/features/main/controllers/task_input_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_colors.dart';

class TaskInputWidget extends StatelessWidget {
  // final Function onClose;
  // TaskInputWidget({required this.onClose})

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    final TaskInputController taskInputController =
    Get.find<TaskInputController>();

    textController.addListener(() {
      taskInputController.isTextEmpty.value =
          textController.text
              .trim()
              .isEmpty;
    });

    String? selectBullet = "task";
    DateTime selectedDate = DateTime.now();

    return GestureDetector(
      // close gesture
      // onTap: onClose, // 수정
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
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.05),
                      blurRadius: 5,
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
                    taskInputController.addTask(textController.text, textController);
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
                  child: Row(),
                ),

                // enter
                Obx(
                      () =>
                      GestureDetector(
                        onTap: () {
                          taskInputController.addTask(textController.text, textController);
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
    )],
    )
    ,
    )
    );
  }
}

Widget _buildOptionItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      child: Row(),
    ),
  );
}
