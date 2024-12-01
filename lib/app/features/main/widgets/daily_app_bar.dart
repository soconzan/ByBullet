import 'package:bybullet/app/features/main/controllers/daily_controller.dart';
import 'package:bybullet/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DailyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DailyController dailyController = Get.find<DailyController>();

  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // profile, title, tasks number
            Row(
              children: [
                // profile
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 25,
                    height: 25,
                    color: AppColors.black,
                    child: Center(
                      child: SvgPicture.asset(
                        'lib/assets/icons/logo.svg',
                        color: AppColors.white,
                        width: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),

                // title
                GestureDetector(
                  onTap: () {
                    dailyController.currentDate.value = DateTime.now(); // currentDate를 오늘 날짜로 재설정
                  },
                  child: Obx(
                        () => Text(
                      dailyController.currentTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 15),

                // tasks number
                // Obx(
                //   () => Wrap(
                //     direction: Axis.horizontal,
                //     spacing: 5,
                //     children: [
                //       _buildTaskInfo('lib/assets/icons/task_bullet.svg', dailyController.taskCount.value),
                //       _buildTaskInfo('lib/assets/icons/priority_bullet.svg', dailyController.priorityCount.value),
                //       _buildTaskInfo('lib/assets/icons/memo_bullet.svg', dailyController.memoCount.value),
                //     ],
                //   ),
                // ),
              ],
            ),

            // current view date
            GestureDetector(
              onTap: () {
                dailyController.currentDate.value = DateTime.now(); // currentDate를 오늘 날짜로 재설정
              },
              child: Obx(
                    () => Text(
                  '${DateFormat('yyyy년 M월').format(dailyController.currentDate.value)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tasks number
  Widget _buildTaskInfo(String svgPath, int count) {
    return Row(
      children: [
        SvgPicture.asset(
          svgPath,
          color: AppColors.black,
          width: 7,
        ),
        SizedBox(width: 5),
        Text(
          "$count",
          style: TextStyle(
            fontSize: 12,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(75);
}
