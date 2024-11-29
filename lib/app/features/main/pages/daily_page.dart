import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/daily_controller.dart';

class DailyPage extends StatelessWidget {
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

      child: Obx(
        () => Text(dailyController.currentDate.string),
      ),
    );
  }
}
