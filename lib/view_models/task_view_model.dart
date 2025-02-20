import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_management/models/task_model.dart';
import 'package:task_management/utility/database_helper.dart';

final taskViewModelProvider =
    StateNotifierProvider<TaskViewModel, List<TaskModel>>(
  (ref) => TaskViewModel(),
);

class TaskViewModel extends StateNotifier<List<TaskModel>> {
  TaskViewModel() : super([]) {
    // Load tasks when ViewModel initializes
    loadTasks();
  }

  Future<void> loadTasks() async {
    final sortBy = Hive.box("settings").get("sortBy", defaultValue: "date");
    final tasks = await DatabaseHelper.fetchTasks(sortBy: sortBy);
    state = tasks;
  }

  // Add Task
  Future<void> addTask(
      String title, String description, TaskPriority priority) async {
    final newTask = TaskModel(
      id: 0,
      title: title,
      description: description,
      date: DateTime.now(),
      // Set current date
      priority: priority, // Use provided priority
    );

    int id = await DatabaseHelper.insertTask(newTask);
    state = [...state, newTask.copyWith(id: id)];
    sortTasks(); // Re-sort tasks
  }

  Future<void> updateTask(int id, String newTitle, String newDescription,
      TaskPriority selectedPriority) async {
    await DatabaseHelper.updateTask(
        id, newTitle, newDescription, selectedPriority);

    state = state.map((task) {
      if (task.id == id) {
        return task.copyWith(
            title: newTitle,
            description: newDescription,
            priority: selectedPriority);
      }
      return task;
    }).toList();
  }

  // Remove Task
  Future<void> removeTask(int id) async {
    await DatabaseHelper.deleteTask(id);

    state = state.where((task) => task.id != id).toList();
  }

  // Toggle Task Completion
  Future<void> toggleTask(int id) async {
    final task = state.firstWhere((task) => task.id == id);

    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);

    await DatabaseHelper.updateTaskStatus(id, updatedTask.isCompleted);

    state = state.map((task) => task.id == id ? updatedTask : task).toList();
  }

  void sortTasks() {
    final sortBy = Hive.box("settings").get("sortBy", defaultValue: "date");
    state = [...state]..sort((a, b) => sortBy == "priority"
        ? a.priority.index.compareTo(b.priority.index) // High first
        : b.date.compareTo(a.date)); // Recent first
  }
}
