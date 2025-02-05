class TaskModel {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  // Convert Task to Map (for database operations)
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "isCompleted": isCompleted ? 1 : 0,
      };

  // Create Task from Map (for database operations)
  factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        isCompleted: json["isCompleted"] == 1,
      );
}
