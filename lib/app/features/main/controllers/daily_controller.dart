import 'package:bybullet/app/features/main/data/task_model.dart';
import 'package:bybullet/app/services/firestore_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../data/daily_task_summary.dart';

class DailyController extends GetxController {
  var currentDate = DateTime.now().obs;
  var tasks = <Task>[].obs;
  var weeklySummaries = <DailyTaskSummary>[].obs;
  var isTaskEditVisible = false.obs;

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

        if (a.isCanceled && !b.isCanceled) return 1;
        if (!a.isCanceled && b.isCanceled) return -1;

        if (timeA.isNotEmpty && timeB.isNotEmpty) {
          return timeA.compareTo(timeB);
        }
        if (timeA.isNotEmpty) return -1;
        if (timeB.isNotEmpty) return 1;

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

  var swipedIndex = Rxn<int>();

  void resetSwipedIndex() {
    swipedIndex.value = null;
  }

  void setSwipedIndex(int index) {
    swipedIndex.value = index;
  }

  // var swipedIndex = (-1).obs;
  // var isRightSwipe = false.obs;
  //
  // void setSwipedIndex(int index, bool isRight) {
  //   swipedIndex.value = index;
  //   isRightSwipe.value = isRight;
  // }
  //
  // void resetSwipedIndex() {
  //   swipedIndex.value = -1;
  //   isRightSwipe.value = false;
  // }

  Future<void> migrateTask(String taskId, String currentDate) async {
    try {
      final date = DateFormat('yyyy-MM-dd').parse(currentDate);
      final updatedDate = date.add(Duration(days: 1));
      final newDateString = DateFormat('yyyy-MM-dd').format(updatedDate);

      await FirestoreService.updateTask(taskId, {"date": newDateString});

      fetchTasks();
      fetchWeeklySummaries();
    } catch (e) {
      print("Error updating task date: $e");
    }
  }

  Future<void> toggleTaskCanceled(String taskId) async {
    try {
      final task = tasks.firstWhere((t) => t.id == taskId);
      final newIsCanceled = !task.isCanceled;

      await FirestoreService.updateTask(taskId, {
        "isCanceled": newIsCanceled,
      });

      fetchTasks();
      fetchWeeklySummaries();
    } catch (e) {
      print("Error toggling task cancel state: $e");
    }
  }

  // Future<void> toggleTaskCanceled(String taskId) async {
  //   final task = tasks.firstWhere((t) => t.id == taskId);
  //   final newState = !task.isCanceled;
  //   // Update task in Firestore
  //   await FirestoreService.updateTask(taskId, {"isCanceled": newState});
  // }


  Future<void> deleteTask(String taskId) async {
    try {
      await FirestoreService.deleteTask(taskId);
      await fetchTasks();
      fetchWeeklySummaries();
    } catch (e) {
      print("Error deleting task: $e");
    }
  }
}
