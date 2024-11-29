import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DailyController extends GetxController {
  var currentDate = DateTime.now().obs;

  var taskCount = 2.obs;
  var priorityCount = 1.obs;
  var memoCount = 1.obs;


  String get currentTitle {
    final today = DateTime.now();
    if (isSameDate(currentDate.value, today)) {
      return "today";
    } else if (isSameDate(currentDate.value, today.subtract(Duration(days: 1)))) {
      return "yesterday";
    } else if (isSameDate(currentDate.value, today.add(Duration(days: 1)))) {
      return "tomorrow";
    } else {
      return DateFormat("EEEE, d").format(currentDate.value);
    }
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void changeDate(int days) {
    currentDate.value = currentDate.value.add(Duration(days: days));
    print("Current Date: ${currentDate.value}");
  }
}
