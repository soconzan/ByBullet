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
            Text('여긴 달력들어갈 자리'),
            SizedBox(
              height: 10,
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
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dailyController.tasks.length,
      itemBuilder: (context, index) {
        final task = dailyController.tasks[index];
        final isCanceled = task["isCanceled"] as bool;
        final time = task["time"];
        final bulletIcon = "lib/assets/icons/${task["bullet"]}_bullet.svg";

        return Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: IntrinsicWidth(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bullet icon
                SvgPicture.asset(
                  bulletIcon,
                  color: isCanceled ? AppColors.mediumGray : AppColors.black,
                  width: 12,
                ),
                SizedBox(width: 10),

                // time
                if (time != null)
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      color: isCanceled
                          ? AppColors.mediumGray
                          : AppColors.darkGray,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                if (time != null) SizedBox(width: 5),

                // text
                Expanded(
                  child: Text(
                    task["text"],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isCanceled ? FontWeight.w400 : FontWeight.w500,
                      color:
                          isCanceled ? AppColors.mediumGray : AppColors.black,
                      decoration: isCanceled
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
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
  }
}
