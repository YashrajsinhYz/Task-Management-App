enum TaskPriority { high, medium, low }

class TaskModel {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime date;
  final TaskPriority priority;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.date,
    required this.priority,
  });

  // Convert Task to Map (for database operations)
  Map<String, dynamic> toMap({bool includeId = true}) {
    return {
      // Include ID only when needed
      if (includeId) "id": id,
      "title": title,
      "description": description,
      // Store as index (0=High, 1=Medium, 2=Low)
      "priority": priority.index,
      "date": date.toIso8601String(),
      "isCompleted": isCompleted ? 1 : 0,
    };
  }

  // Create Task from Map (for database operations)
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      isCompleted: map['isCompleted'] == 1,
      priority: TaskPriority.values[map['priority']], // Convert index to Enum
    );
  }

  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? date,
    TaskPriority? priority,
  }) {
    return TaskModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

