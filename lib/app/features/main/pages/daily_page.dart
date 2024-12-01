import 'package:bybullet/app/features/main/widgets/weekly_calendar_with_tasks.dart';
import 'package:bybullet/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/daily_controller.dart';

class DailyPage extends StatelessWidget {
  final DailyController dailyController = Get.find<DailyController>();

  @override
  Widget build(BuildContext context) {
    dailyController.fetchTasks();

    return GestureDetector(
      // Swipe
      onHorizontalDragEnd: (details) {
        // right >>
        if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
          dailyController.changeDate(-1);
        }
        // left <<
        else if (details.primaryVelocity != null &&
            details.primaryVelocity! < 0) {
          dailyController.changeDate(1);
        }
      },

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // mini dialog
            WeeklyCalendarWithTasks(),
            SizedBox(
              height: 20,
            ),

            // task list
            Obx(() {
              if (dailyController.tasks.isEmpty) {
                return Center(child: Text("No tasks for today."));
              }
              return _buildTaskList();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Expanded(
      child: Obx(() {
        final tasks = dailyController.tasks;
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final bulletIcon = "lib/assets/icons/${task.bullet}_bullet.svg";

            return GestureDetector(
              onTap: task.bullet == "task" || task.bullet == "completed"
                  ? () => dailyController.toggleTaskBullet(task.id, task.bullet)
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Bullet icon
                    SvgPicture.asset(
                      bulletIcon,
                      color: task.isCanceled ? AppColors.mediumGray : AppColors.black,
                      width: 12,
                    ),
                    SizedBox(width: 10),

                    // Task text
                    Expanded(
                      child: Text(
                        task.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: task.isCanceled ? AppColors.mediumGray : AppColors.black,
                          decoration: task.isCanceled ? TextDecoration.lineThrough : null,
                          decorationColor: AppColors.mediumGray,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }


}
