import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sava Task
  Future<void> saveTask(String text, String bullet, DateTime date) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null)
      throw Exception("User not logged in");

    final uid = currentUser.uid;
    final taskData = {
      "bullet": bullet,
      "text": text,
      "date": Timestamp.fromDate(date),
      "createdAt": Timestamp.now(),
    };

    await _firestore
        .collection("users")
        .doc(uid)
        .collection("tasks")
        .add(taskData);
  }
}
