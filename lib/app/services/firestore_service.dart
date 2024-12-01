import 'package:bybullet/app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../features/main/data/daily_task_summary.dart';
import '../features/main/data/task_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user data
  static Future<void> saveUser(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).set(data);
    } catch (e) {
      print("Error saving user: $e");
      rethrow;
    }
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  // Save Task
  static Future<void> saveTask(
      String text, String bullet, DateTime date, TimeOfDay? time) async {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) throw Exception("User not logged in");

    final uid = currentUser.uid;
    final taskData = {
      "bullet": bullet,
      "text": text,
      "date": DateFormat('yyyy-MM-dd').format(date),
      "time": time != null
          ? "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}"
          : null,
      "createdAt": Timestamp.now(),
    };

    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("tasks")
          .add(taskData);
    } catch (e) {
      throw Exception("Error adding task: $e");
    }
  }

  // Get Task List
  static Future<List<Task>> fetchTasks(DateTime currentDate) async {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) throw Exception("User not logged in");

    final uid = currentUser.uid;

    try {
      print("Current user Id: ${currentUser.uid}");
      final snapshot = await _firestore
          .collection("users")
          .doc(uid)
          .collection("tasks")
          .where("date",
              isEqualTo: DateFormat('yyyy-MM-dd').format(currentDate))
          .get();

      return snapshot.docs
          .map((doc) => Task.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error fetching tasks: $e");
    }
  }

  // Update Task
  static Future<void> updateTask(
      String taskId, Map<String, dynamic> updates) async {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) throw Exception("User not logged in");

    final uid = currentUser.uid;
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .collection("tasks")
          .doc(taskId)
          .update(updates);
    } catch (e) {
      throw Exception("Error updating task: $e");
    }
  }

  // Fetch task counts
  static Future<Map<String, int>> fetchTaskCounts(DateTime date) async {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) throw Exception("User not logged in");
    final uid = currentUser.uid;

    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    try {
      final snapshot = await _firestore
          .collection("users")
          .doc(uid)
          .collection("tasks")
          .where("date", isEqualTo: formattedDate)
          .get();

      int taskCount = 0;
      int completedCount = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final bullet = data["bullet"] as String?;
        if (bullet == "task") {
          taskCount++;
        } else if (bullet == "completed") {
          completedCount++;
        }
      }

      return {
        "taskCount": taskCount,
        "completedCount": completedCount,
      };
    } catch (e) {
      print("Error fetching task counts: $e");
      return {
        "taskCount": 0,
        "completedCount": 0,
      };
    }
  }

  static Future<List<DailyTaskSummary>> fetchWeeklyTaskSummaries(
      DateTime currentDate) async {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) throw Exception("User not logged in");

    final uid = currentUser.uid;

    final startOfWeek = currentDate.subtract(Duration(days: 3));
    final endOfWeek = currentDate.add(Duration(days: 3));
    final startDate = DateFormat('yyyy-MM-dd').format(startOfWeek);
    final endDate = DateFormat('yyyy-MM-dd').format(endOfWeek);

    try {
      final snapshot = await _firestore
          .collection("users")
          .doc(uid)
          .collection("tasks")
          .where("date", isGreaterThanOrEqualTo: startDate)
          .where("date", isLessThanOrEqualTo: endDate)
          .get();

      final Map<String, Map<String, int>> summaryMap = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final date = data["date"] as String? ?? "";

        if (!summaryMap.containsKey(date)) {
          summaryMap[date] = {"taskCount": 0, "completedCount": 0};
        }

        final bullet = data["bullet"] as String? ?? "";
        if (bullet == "task") {
          summaryMap[date]!["taskCount"] =
              (summaryMap[date]!["taskCount"] ?? 0) + 1;
        } else if (bullet == "completed") {
          summaryMap[date]!["completedCount"] =
              (summaryMap[date]!["completedCount"] ?? 0) + 1;
        }
      }

      return summaryMap.entries
          .map((entry) => DailyTaskSummary.fromMap(entry.key, entry.value))
          .toList();
    } catch (e) {
      print("Error fetching weekly task summaries: $e");
      return [];
    }
  }
}
