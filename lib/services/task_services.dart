import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

class TaskServices {
  final FirebaseAuth _auth =
      FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addTask(Task task) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .add(task.toMap());
  }
}
