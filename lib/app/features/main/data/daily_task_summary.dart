class DailyTaskSummary {
  final String date;
  final int taskCount;
  final int completedCount;

  DailyTaskSummary({
    required this.date,
    required this.taskCount,
    required this.completedCount,
  });

  factory DailyTaskSummary.fromMap(String date, Map<String, dynamic> data) {
    return DailyTaskSummary(
      date: date,
      taskCount: data['taskCount'] ?? 0,
      completedCount: data['completedCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'taskCount': taskCount,
      'completedCount': completedCount,
    };
  }
}
