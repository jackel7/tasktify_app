class Task {
  final String? id;
  final String title;
  final String description;
  final String priority; // ✅ fixed
  final int createdAt;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      "description": description,
      "priority": priority, // ✅ correct key
      "createdAt": createdAt,
    };
  }

  factory Task.fromMap(
    Map<dynamic, dynamic> data,
    String id,
  ) {
    return Task(
      id: id,
      title: data["title"] ?? '',
      description: data["description"] ?? '',
      priority:
          data['priority'] ?? "Medium", // ✅ fixed
      createdAt: data['createdAt'] ?? 0,
    );
  }
}
