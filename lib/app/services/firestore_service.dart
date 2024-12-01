import 'package:bybullet/app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // save user data
  static Future<void> saveUser(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).set(data);
    } catch (e) {
      print("Error saving user: $e");
      rethrow;
    }
  }

  // get user data
  static Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  // Sava Task
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

  // Get Task list
  static Future<List<Map<String, dynamic>>> fetchTasks(
      DateTime currentDate) async {
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

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "text": data["text"] ?? "",
          "bullet": data["bullet"] ?? "",
          "time": data["time"],
          "isCanceled": data["isCanceled"] ?? false,
          "createdAt": (data["createdAt"] as Timestamp).toDate(),
        };
      }).toList();
    } catch (e) {
      throw Exception("Error fetching tasks: $e");
    }
  }
}
