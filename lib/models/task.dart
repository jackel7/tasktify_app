import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String? id;
  final String title;
  final String task;
  final String priority;
  final bool isDone;
  final int createdAt;

  Task({
    this.id,
    required this.title,
    required this.task,
    required this.priority,
    required this.createdAt,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      "task": task,
      "priority": priority,
      "createdAt": createdAt,
      'isDone': isDone,
    };
  }

  factory Task.fromDocument(
    DocumentSnapshot doc,
  ) {
    final data =
        doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'],
      task: data['task'],
      priority: data['priority'],
      createdAt: data['createdAt'],
      isDone: data['isDone'],
    );
  }
}
