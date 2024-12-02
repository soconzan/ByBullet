import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_colors.dart';
import '../controllers/daily_controller.dart';
import '../data/daily_task_summary.dart';

class WeeklyCalendarWithTasks extends StatelessWidget {
  final DailyController dailyController = Get.find<DailyController>();

  @override
  Widget build(BuildContext context) {
    dailyController.fetchWeeklySummaries();

    return Obx(() {
      final today = DateTime.now();
      final startOfWeek =
          dailyController.currentDate.value.subtract(Duration(days: 3));
      final days =
          List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((date) {
          final formattedDate = DateFormat('yyyy-MM-dd').format(date);
          final summary = dailyController.weeklySummaries.firstWhere(
            (summary) => summary.date == formattedDate,
            orElse: () => DailyTaskSummary(
                date: formattedDate, taskCount: 0, completedCount: 0),
          );

          final isToday = dailyController.isSameDate(date, today);
          final isSelected = dailyController.isSameDate(
              date, dailyController.currentDate.value);
          final taskCount = summary.taskCount + summary.completedCount;

          return GestureDetector(
            onTap: () {
              dailyController.currentDate.value = date;
            },
            child: Column(
              children: [
                // Day of week
                Text(
                  DateFormat.E('ko_KR').format(date),
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? AppColors.black : AppColors.darkGray,
                  ),
                ),
                SizedBox(height: 5),

                // Task count
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color:
                        (summary.taskCount == 0 && summary.completedCount > 0)
                            ? AppColors.black
                            : AppColors.mediumGray,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text(
                      "$taskCount",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),

                // Date
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.black
                        : isToday
                            ? AppColors.mediumGray
                            : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "${date.day}",
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.white
                            : isToday
                            ? AppColors.black
                            : AppColors.darkGray,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
