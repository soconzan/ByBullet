import 'package:bybullet/app/features/main/data/task_model.dart';
import 'package:bybullet/app/services/firestore_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../data/daily_task_summary.dart';

class DailyController extends GetxController {
  var currentDate = DateTime.now().obs;
  var tasks = <Task>[].obs;
  var weeklySummaries = <DailyTaskSummary>[].obs;

  var taskCount = 0.obs;
  var completedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    ever(currentDate, (_) {
      fetchTasks();
      fetchWeeklySummaries();
    });
  }

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
      return DateFormat("M. d. EEEE").format(currentDate.value);
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
        final timeA = a.time ?? "";
        final timeB = b.time ?? "";

        if (timeA.isNotEmpty && timeB.isNotEmpty) {
          return timeA.compareTo(timeB);
        }
        if (timeA.isNotEmpty) return -1;
        if (timeB.isNotEmpty) return 1;

        if (a.isCanceled && !b.isCanceled) return 1;
        if (!a.isCanceled && b.isCanceled) return -1;

        return a.createdAt.compareTo(b.createdAt);
      });

      tasks.value = fetchedTasks;
      print("Tasks fetched: ${tasks.length}");
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  Future<void> fetchTaskCounts() async {
    try {
      final counts = await FirestoreService.fetchTaskCounts(currentDate.value);

      taskCount.value = counts['taskCount'] ?? 0;
      completedCount.value = counts['completedCount'] ?? 0;

      print(
          "Task Count: ${taskCount.value}, Completed Count: ${completedCount.value}");
    } catch (e) {
      print("Error fetching task counts: $e");
    }
  }

  Future<void> fetchWeeklySummaries() async {
    try {
      final summaries =
          await FirestoreService.fetchWeeklyTaskSummaries(currentDate.value);
      weeklySummaries.value = summaries;
    } catch (e) {
      print("Error fetching weekly summaries: $e");
    }
  }

  Future<void> toggleTaskBullet(String taskId, String currentBullet) async {
    final newBullet = currentBullet == "task" ? "completed" : "task";
    try {
      await FirestoreService.updateTask(taskId, {"bullet": newBullet});
      fetchTasks();
      fetchWeeklySummaries();
    } catch (e) {
      print("Error updating bullet: $e");
    }
  }
}
