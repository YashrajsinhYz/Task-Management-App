import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/models/task_model.dart';

final taskViewModelProvider =
    StateNotifierProvider<TaskViewModel, List<TaskModel>>(
  (ref) => TaskViewModel(),
);

class TaskViewModel extends StateNotifier<List<TaskModel>> {
  TaskViewModel() : super([]);

  // Add Task
  void addTask(String title, String description) {
    final newTask =
        TaskModel(id: state.length + 1, title: title, description: description);
    state = [...state, newTask]; // Update state
  }

  // Toggle Task Completion
  void toggleTask(int id) {
    state = state.map((task) {
      return task.id == id
          ? TaskModel(
              id: task.id,
              title: task.title,
              isCompleted: !task.isCompleted,
              description: task.description)
          : task;
    }).toList();
  }

  // Remove Task
  void removeTask(int id) {
    state = state.where((task) => task.id != id).toList();
  }
}
