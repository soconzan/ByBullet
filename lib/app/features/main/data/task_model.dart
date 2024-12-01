import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String text;
  final String bullet;
  final String date;
  final String? time;
  final bool isCanceled;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.text,
    required this.bullet,
    required this.date,
    this.time,
    required this.isCanceled,
    required this.createdAt,
  });

  factory Task.fromFirestore(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      text: data["text"] ?? "",
      bullet: data["bullet"] ?? "task",
      date: data["date"],
      time: data["time"],
      isCanceled: data["isCanceled"] ?? false,
      createdAt: (data["createdAt"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "bullet": bullet,
      "date": date,
      "time": time,
      "isCanceled": isCanceled,
      "createdAt": createdAt,
    };
  }
}
