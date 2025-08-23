import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/task.dart';

class TaskServices {
  final FirebaseAuth _auth =
      FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase
      .instance
      .ref();

  Future<void> addTask(Task task) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    final taskRef = _db
        .child('users')
        .child(user.uid)
        .child('tasks');
    final newTaskRef = taskRef.push();
    await newTaskRef.set(task.toMap());
  }
}
