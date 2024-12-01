import 'package:bybullet/app/services/firestore_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DailyController extends GetxController {
  var currentDate = DateTime.now().obs;
  var tasks = <Map<String, dynamic>>[].obs;

  var taskCount = 2.obs;
  var priorityCount = 1.obs;
  var memoCount = 1.obs;

  String get currentTitle {
    final today = DateTime.now();
    if (isSameDate(currentDate.value, today)) {
      return "today";
    } else if (isSameDate(
        currentDate.value, today.subtract(Duration(days: 1)))) {
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

  Future<void> fetchTasks() async {
    try {
      final fetchedTasks = await FirestoreService.fetchTasks(currentDate.value);

      fetchedTasks.sort((a, b) {
        final timeA = a["time"] as String? ?? "";
        final timeB = b["time"] as String? ?? "";

        if (timeA.isNotEmpty && timeB.isNotEmpty) {
          return timeA.compareTo(timeB);
        }
        if (timeA.isNotEmpty) return -1;
        if (timeB.isNotEmpty) return 1;

        final isCanceledA = a["isCanceled"] as bool? ?? false;
        final isCanceledB = b["isCanceled"] as bool? ?? false;

        if (isCanceledA && !isCanceledB) return 1;
        if (!isCanceledA && isCanceledB) return -1;

        final createdAtA = a["createdAt"] as DateTime;
        final createdAtB = b["createdAt"] as DateTime;

        return a["createdAt"].compareTo(b["createdAt"]);
      });

      tasks.value = fetchedTasks;
      print(tasks);
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }
}
