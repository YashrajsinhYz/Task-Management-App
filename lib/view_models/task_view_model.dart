import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/models/task_model.dart';

final taskViewModelProvider = StateNotifierProvider<TaskViewModel, List<Task>>(
      (ref) => TaskViewModel(),
);

class TaskViewModel extends StateNotifier<List<Task>> {
  TaskViewModel() : super([]);

  // Add Task
  void addTask(String title) {
    final newTask = Task(id: state.length + 1, title: title);
    state = [...state, newTask]; // Update state
  }

  // Toggle Task Completion
  void toggleTask(int id) {
    state = state.map((task) {
      return task.id == id ? Task(id: task.id, title: task.title, isCompleted: !task.isCompleted) : task;
    }).toList();
  }

  // Remove Task
  void removeTask(int id) {
    state = state.where((task) => task.id != id).toList();
  }
}
